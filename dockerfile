FROM node:lts-trixie

ENV TZ=America/Toronto

ADD --keep-git-dir=false https://github.com/junegunn/fzf.git /tmp/installables/fzf
ADD bin /tmp/installables/

ARG USER=coder

RUN <<EOF
apt-get update
apt-get install -y sudo git curl python3-venv python3-pip
ln /usr/bin/python3 /usr/bin/python
rm -rf /var/lib/apt/lists/* /home/node
/tmp/installables/fzf/install --all
cp /tmp/installables/fzf/bin/* /usr/local/bin/
cat /root/.fzf.bash >> /etc/skel/.bashrc
curl -fsSL https://bun.sh/install | bash
mv $HOME/.bun/bin/bun /usr/local/bin/
ln /usr/local/bin/bun /usr/local/bin/bunx
chmod a+x /usr/local/bin/bun /usr/local/bin/bunx
tar -C /opt -xzf /tmp/installables/nvim-linux-x86_64.tar.gz
ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/
ln -sf /opt/nvim-linux-x86_64/lib/nvim /usr/local/lib/
tar -xvf /tmp/installables/zellij*.tar.gz -C /tmp/installables
install /tmp/installables/zellij -D -t /usr/local/bin/
sudo dpkg -i /tmp/installables/fd_10.3.0_amd64.deb
sudo dpkg -i /tmp/installables/ripgrep_15.1.0-1_amd64.deb
tar xf /tmp/installables/lazygit*.tar.gz /tmp/lazygit
install /tmp/lazygit -D -t /usr/local/bin/
useradd ${USER} --groups sudo --no-create-home --shell /bin/bash
echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER}
chmod 0440 /etc/sudoers.d/${USER}
EOF

USER ${USER}
WORKDIR /home/${USER}
