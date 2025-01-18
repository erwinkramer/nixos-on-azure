# NixOS on Azure

Run NixOS, with [Arion](https://docs.hercules-ci.com/arion/), on an Azure Gen 2 VM.

## Preparation

1. Set your username in the `flake.nix` file
1. use [direnv](https://github.com/nix-community/nix-direnv) or run `nix develop`
1. run `az login` and login with your Azure credentials
1. Create an RSA SSH key pair (name=`id_rsa`), [ed25519 keys are not supported by Azure](https://learn.microsoft.com/en-us/troubleshoot/azure/virtual-machines/ed25519-ssh-keys):

```powershell
ssh-keygen -t rsa -b 4096 -C "erwinkramer@guanchen.nl" -f $HOME/.ssh/id_rsa
```

## Upload image

it can take a while to upload the `.vhd` (for me it is +/- 50 min), <br>
if the upload time-out; you may want to change the token duration. <br>
also don't look at the azcopy log file, it spams 500 errors but these can be ignored.

```sh
./upload-image.sh --resource-group images --image-name nixos-gen2
```

## Create VM

```sh
./boot-vm.sh --resource-group vms --image nixos-gen2 --vm-name nixos
```

## Build image (only)

```sh
nix build .#azure-image --impure
```

## SSH into server

```sh
ssh -i ~/.ssh/id_rsa guanchen@<public_ip>
```

> - username you have set in the `flake.nix` file
> - public IP will be printed with running the `boot-vm.sh` script

---

```
❯ neofetch
          ▗▄▄▄       ▗▄▄▄▄    ▄▄▄▖            rudesome@nixos 
          ▜███▙       ▜███▙  ▟███▛            -------------- 
           ▜███▙       ▜███▙▟███▛             OS: NixOS 23.11.20240215.c68a9fc (Tapir) x86_64
            ▜███▙       ▜██████▛              Host: Microsoft Corporation Virtual Machine
     ▟█████████████████▙ ▜████▛     ▟▙        Kernel: 6.7.4
    ▟███████████████████▙ ▜███▙    ▟██▙       Uptime: 45 secs
           ▄▄▄▄▖           ▜███▙  ▟███▛       Packages: 368 (nix-system), 798 (nix-user)
          ▟███▛             ▜██▛ ▟███▛        Shell: zsh 5.9
         ▟███▛               ▜▛ ▟███▛         Terminal: /dev/pts/0
▟███████████▛                  ▟██████████▙   CPU: Intel Xeon Platinum 8171M (1) @ 2.095GHz
▜██████████▛                  ▟███████████▛   Memory: 384MiB / 3424MiB
      ▟███▛ ▟▙               ▟███▛
     ▟███▛ ▟██▙             ▟███▛
    ▟███▛  ▜███▙           ▝▀▀▀▀
    ▜██▛    ▜███▙ ▜██████████████████▛
     ▜▛     ▟████▙ ▜████████████████▛
           ▟██████▙       ▜███▙
          ▟███▛▜███▙       ▜███▙
         ▟███▛  ▜███▙       ▜███▙
         ▝▀▀▀    ▀▀▀▀▘       ▀▀▀▘
```

# Credits

### [Society for the Blind](https://github.com/society-for-the-blind/nixos-azure-deploy)
### [Plommonsorbet](https://github.com/Plommonsorbet/nixos-azure-gen-2-vm-example)
