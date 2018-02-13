echo "Enter the puppetmaster hostname"
read MASTER

echo "Enter the environment name"
read PUPPETENV


# add puppet repo
mkdir setup-temp
cd setup-temp

sudo apt-get update
sudo apt-get install ruby-full facter hiera bundler

wget https://github.com/puppetlabs/puppet/archive/5.4.0.zip
unzip 5.4.0.zip
cd puppet-5.4.0

bundle install --path .bundle/gems
sudo bundle update
ruby install.rb

# Add puppet path for future sessions

cat >> /etc/profile.d/puppetpath.sh << \EOF
    PATH=$PATH:/opt/puppetlabs/bin
EOF

# Add puppet path for this session
export PATH=$PATH:/opt/puppetlabs/bin || exit 1

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
