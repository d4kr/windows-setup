# Install python
choco install -y python --version=3.7.4

# Refresh path
refreshenv

# Update pip
python -m pip install --upgrade pip

# Install ML related python packages through pip
pip install numpy

# Get Visual Studio C++ Redistributables
choco install -y vcredist20