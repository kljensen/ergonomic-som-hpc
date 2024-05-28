+++
title = "Running Jupyter notebooks and RStudio"
+++

Many folks like to write code in interactive "notebooks"
such as [Jupyter](https://jupyter.org) or [RStudio](https://rstudio.com).
Now, in my humble opinion, _usually_ if you have the kind
of computing need that calls for the HPC, it's the kind
of computing need that is best developed outside of a notebook.
But, different strokes for different folks. 🤷

Notebooks like Jupyter and RStudio are _servers_ to which
you connect over HTTP. When you run them locally, you'll
typically connect to them at some `localhost` URL like
`http://localhost:8888`. When you run them on Google Colab
connect at some URL like `https://colab.research.google.com/drive/15yFH_lYzv...`. 

When you run them on the HPC, you're going to have a problem.
Say you start the server on node C14 of the HPC. The server
starts listening on `localhost:8888` on C14. Well, how do you
connect to that? C14 is not accessible from the outside world...it'
only internally accessible on the HPC. (This is a good thing.)

The answer is that you need to use SSH port forwarding and tunneling. (A few
tutorials on that subject:
[1](https://iximiuz.com/en/posts/ssh-tunnels/),
[2](https://goteleport.com/blog/ssh-tunneling-explained/).)

In SSH port forwarding, you tell your SSH client to
take
network traffic going to
port X on machine A and forward it to port Y on machine B. You would do that
if you couldn't easily connect to machine B's port Y directly or if 
you wanted to encrypt the connection between A and B.

Now, imagine an even more complicated case. There is a machine
C, to which we wish to connect, but which can only be accessed
by machine B (not A). This is the situation on the HPC. To get
to machine C, we need to use "SSH tunneling", which is like 
port forwarding twice.

Imagine we're on the HPC and we launch a Jupyter
notebook using Slurm, the job scheduler. 

```sh
srun --nodelist c9 jupyter notebook --port 8888
```

This will start a Jupyter notebook on node C9 of the HPC.
(Note that here I've assumed some things about how you installed
Python and such. I'm not covering that here.)
How do we connect to it? 

Well, you need to know a few things. First, the c9 node has
a DNS name of `c9.cluster` but _only_ the HPC can resolve that:
if you type that into your browser, you won't get squat. To
connect to the Jupyter notebook, you need to connect to the
HPC-SMS node (the entry/head) node and then tunnel through
that to the c9 node. 

So, from your laptop, here is how you do that:

```sh
ssh -NL 9999:localhost:8888 -J klj39@hpc-sms.som.yale.edu klj39@c9.cluster
```

Here's a breakdown of the command:

* `-NL 9999:localhost:8888`: Sets up a tunnel wherein your local machine's port 9999 forwards to the port 8888 on the host `c9.cluster`. `N` tells SSH that no remote commands will be executed, and `L` specifies that the port forwarding is to be done from the local side.
* `-J klj39@hpc-sms.som.yale.edu`: This option is for "jump host" configuration. It specifies an intermediate host (`hpc-sms.som.yale.edu`) through which the SSH connection is tunneled. `klj39` is the username on the jump host. Yours will be different!
* `klj39@c9.cluster`: This is your final destination. `c9.cluster` specifies the specific cluster node, and `klj39` is the username at that node.

## Making that easier

You can make this easier by setting up an SSH config file.
Here is a snippet from mine which is at `~/.ssh/config`
on my Mac:

```
Host hpc
    User klj39
    HostName hpc-sms.som.yale.edu
    ForwardAgent yes
Host c?
    User klj39
    ProxyJump hpc
    Hostname %h.cluster
Host c??
    User klj39
    ProxyJump hpc
    Hostname %h.cluster
```

Now, when I want to port forward to a node, I can just type

```
ssh -NL 9999:localhost:8888 c9
```

and I will be able to access c9's port 8888 at `localhost:9999`
in my browser. That connection is transparently tunneled through
the jump/bastion host `hpc-sms.som.yale.edu`.

## RStudio

The same principles apply to RStudio. Unfortunately, as I
am writing this, I see that it's not as trivial to run rstudio
on the HPC as I remembered. In any case...same thing: you can
start it listening on a port, then tunnel to that port through
the HPC-SMS node.



