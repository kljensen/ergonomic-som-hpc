+++
title = "Connecting to the HPC"
+++

This is a brief guide to connecting to the Yale SOM HPC. If you
have trouble, you can email me or obviously SOMIT (preferably SOMIT 😂).


## Getting an account

First, you need an account on the HPC. To get one,
email [somit@yale.edu](mailto:somit@yale.edu). Once
you have an account you can connect to the HPC using
[SSH](https://www.cloudflare.com/learning/access-management/what-is-ssh/#).

## Installing an SSH client

If you're on MacOS or Linux, you already have an SSH client, congratulations. If you're on Windows, you'll want to follow
[these instructions](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse) to install
the OpenSSH client. You just need the _client_, not the _server_.

OpenSSH has been available on Windows since about 2018. Prior to
that time, most people used [Putty](https://www.putty.org). I don't
think that is recommended any more.

## Connecting to the HPC via SSH

The Yale SOM HPC is only available from on-campus or via the Yale VPN. To connect to the Yale VPN, you can use the
[Cisco AnyConnect VPN client](https://studenttechnology.yale.edu/new-students/set-virtual-private-network-vpn). It's likely that SOM
IT already put this on your laptop and you regularly. It's a lot
less annoying now that you don't have to use two-factor authentication
*every time*.

Once you're on the Yale Network, you can connect to the HPC using
a command like the following:

```sh
ssh klj39@hpc-sms.som.yale.edu
```

You can see my netid `klj39` in that command. Yours is different 😂.

If you haven't setup SSH keys, you'll be prompted for your CAS password.
After successfully authenticating, you'll be dumped in a bash shell
running on the main "entry" node. Congrats.

## Setting up SSH public keys

Using your password every time you connect to the HPC is not super
smart security-wise and, more importantly, it imposes a high marginal
cost to connecting, which is not cool because we would like to have
tight feedback cycles whilst writing new code. 

To enable password-less authentication, we
want to set up "public key authentication" and the first step of
that is to create public/private keypair. To do that, on your
terminal or Windows PowerShell, you want to run this command

```sh
ssh-keygen -t ed25519
```
It's best to choose a non-empty passphrase for your key. But,
I admit to living part of my life without a passphrase. 


If you're on a Mac or Linux machine, that will create two files:
`~/.ssh/id_ed25519` and `~/.ssh/id_ed25519.pub`. The first is your
private key and the second is your public key. If you're on Windows,
the files will be in your home directory, probably `C:\Users\yourname\.ssh`.

Next, you want to copy your public key to the HPC. You can do that
with the following command on MacOS or Linux:

```bash
ssh-copy-id -i ~/.ssh/id_ed25519 klj39@hpc-sms.som.yale.edu
```

and this command on Windows:

```
type $env:USERPROFILE\.ssh\id_rsa.pub | ssh klj39@hpc-sms.som.yale.edu
 "cat >> .ssh/authorized_keys"
```

Obviously, replace `klj39` with your netid. You'll be prompted for
your CAS password. After that, you should be able to connect to the
HPC without a password. When you do something like

```sh
ssh klj39@hpc-sms.som.yale.edu
```

You'll just get right in!

If you're still being prompted for a password,
well, that's beyond the scope of my brief tutorial. You might want to
just ask an LLM.

