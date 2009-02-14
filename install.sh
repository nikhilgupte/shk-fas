# Script to install and setup the FAS production environment
# This script will install ruby, rails and everything required to run the FAS application
#
# Dependencies:
# * Linux installed with gcc and all development libraries
# * openssl
# * postgresql and postgresql-devel
# * zlib-dev packages

echo "installing ruby..."
if [ ! -f ruby-1.8.7-p72.tar.gz ];
	then
		wget ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p72.tar.gz
fi
tar -xzf ruby-1.8.7-p72.tar.gz && cd ruby-1.8.7*
./configure && make
sudo make install
echo 'ruby installed.'

echo "Installing rubygems..."
if [ ! -f rubygems-1.3.1.tgz ]; then wget http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz ; fi
tar -xzf rubygems-1.3.1.tgz
cd rubygems-1.3.1
ruby setup.rb
cd ..
echo "rubygems installed!"

echo "installing rails..."
sudo gem install rails -v 2.2.2
echo "rails installed!"

# install the postgres ruby drivers
sudo gem install ruby-pg
