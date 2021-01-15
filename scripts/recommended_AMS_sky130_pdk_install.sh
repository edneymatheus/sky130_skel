echo "Installation of sky130 open source PDK will begin..."

echo "You will need root permissions to perform tools installation..."

if [[ $EUID -ne 1000 ]]; then
   echo "This script must be run as user"
   exit 1
fi


echo "Creating pdks directory..."

cd /
sudo mkdir edatools
cd edatools
#sudo mkdir tools
#cd tools
sudo mkdir pdks
cd pdks

export TOOLS_DIR=/edatools
#export TOOLS_DIR=/tools

echo "Cloning sky130 libraries..."
sudo git clone https://github.com/google/skywater-pdk
cd skywater-pdk
#sudo git submodule init libraries/sky130_fd_io/latest
sudo git submodule init libraries/sky130_fd_pr/latest
sudo git submodule init libraries/sky130_fd_sc_hd/latest
#sudo git submodule init libraries/sky130_fd_sc_hdll/latest
#sudo git submodule init libraries/sky130_fd_sc_hs/latest
#sudo git submodule init libraries/sky130_fd_sc_ms/latest
#sudo git submodule init libraries/sky130_fd_sc_ls/latest
#sudo git submodule init libraries/sky130_fd_sc_lp/latest
#sudo git submodule init libraries/sky130_fd_sc_hvl/latest
sudo git submodule update
#sudo make timing #uncomment just for digital flow 

cd ..

#uncomment below for Open_PDKs compatibility
#echo "Cloning Open_PDKs tool and setting up for tool flow compatibility..."
#sudo git clone git://opencircuitdesign.com/open_pdks
#cd open_pdks
#sudo git checkout open_pdks-1.0
#sudo ./configure --enable-sky130-pdk=$TOOLS_DIR/pdks/skywater-pdk --with-sky130-local-path=$TOOLS_DIR/pdks
#cd sky130
#sudo make
#sudo make install

echo "Creating sky130_skel..."
cd ~
mkdir sky130_skel
cd sky130_skel
 
echo "Preparing libraries for AMS flow using XSchem..."

echo "Cloning XSchem_sky130 repo..."
git clone https://github.com/StefanSchippers/xschem_sky130.git

echo "Setting up sky130 libraries..."
cd $TOOLS_DIR/pdks/skywater-pdk/libraries
sudo cp -r sky130_fd_pr sky130_fd_pr_ngspice
cd sky130_fd_pr_ngspice/latest
sudo patch -p2 < ~/sky130_skel/xschem_sky130/sky130_fd_pr.patch

echo "#####################################################################################################################"
echo "To complete the workarea setup you need to update the last two lines of the file 'xschemrc' with the following paths:"
echo "set SKYWATER_MODELS $TOOLS_DIR/pdks/skywater-pdk/libraries/sky130_fd_pr_ngspice/latest"
echo "set SKYWATER_STDCELLS $TOOLS_DIR/pdks/skywater-pdk/libraries/sky130_fd_sc_hd/latest"
echo "#####################################################################################################################"

cd ~/sky130_skel/xschem_sky130

echo "Recommended sky130 open source PDK installation for AMS flow done!"