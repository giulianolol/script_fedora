cat > comandos_fdisk.txt <<EOF
n
p



t
8e
w
EOF
cat > comandos_fdisk_sdc.txt <<EOF
n 
p


+2.5GB
n




t

8e
t
1
8e
w
EOF
sudo fdisk /dev/sdc < comandos_fdisk_sdc.txt
sudo fdisk /dev/sdd < comandos_fdisk.txt
sudo fdisk /dev/sde < comandos_fdisk.txt

sudo pvcreate /dev/sdc1
sudo pvcreate /dev/sdc2
sudo pvcreate /dev/sdd1
sudo pvcreate /dev/sde1

sudo vgcreate vg_datos /dev/sdc1 /dev/sdd1
sudo vgcreate vg_temp /dev/sde1 /dev/sdc2

sudo lvcreate -L 10M -n lv_docker vg_datos
sudo lvcreate -L 2.5 -n lv_workareas vg_datos
sudo lvcreate -L 1G -n lv_swap vg_temp

sudo lvextend -L 2.5G /dev/vg_temp/lv_swap
sudo lvextend -L 2.5G /dev/vg_datos/lv_workareas

sudo mkfs.ext4 /dev/vg_datos/lv_docker
sudo mkdir -p /var/lib/docker
sudo mount /dev/vg_datos/lv_docker /var/lib/docker

sudo mkfs.ext4 /dev/vg_datos/lv_workareas
sudo mkdir -p /work
sudo mount /dev/vg_datos/lv_workareas /work

sudo swapoff /dev/vg_temp/lv_swap
sudo mkswap /dev/vg_temp/lv_swap
sudo swapon /dev/vg_temp/lv_swap

echo "/dev/vg_datos/lv_docker /var/lib/docker ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/vg_datos/lv_workareas /work ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/vg_temp/lv_swap none swap sw 0 0" | sudo tee -a /etc/fstab
sudo mount -a
