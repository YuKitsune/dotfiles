1. Copy SSH Keys
```sh
# Add primary SSH key
ssh-copy-id -i ~/.ssh/id_ed25519_sk.pub  USERNAME@HOST

# Add backup SSH key
ssh-copy-id -i ~/.ssh/id_ed25519_sk_backup.pub  USERNAME@HOST
```

2. Disable password authentication
Add `PasswordAuthentication no` to `/etc/ssh/sshd_config`, then run sudo service ssh reload.
