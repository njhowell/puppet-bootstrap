echo "Enter the puppetmaster hostname"
read MASTER

echo "Enter the environment name"
read PUPPETENV


# add puppet repo
mkdir setup-temp
cd setup-temp

wget https://apt.puppetlabs.com/puppet-release-jessie.deb || exit 1
dpkg -i puppet-release-jessie.deb || exit 1
apt update || exit 1


# install puppet-agent

apt install puppet -y || exit 1


puppet config set server $MASTER --section main || exit 1

puppet config set environment $PUPPETENV --section main || exit 1

puppet agent -t

echo 'Go sign this node and press enter when done...'
read dummy

# Enable puppet
puppet agent --enable

# Run it for reals
puppet agent -t

# Enable the service
puppet resource service puppet ensure=running enable=true
