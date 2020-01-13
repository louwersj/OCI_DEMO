# Generic first boot script for creating a ngnix web node.
#
#
# --COPYRIGHT----------------------------------------------------------
# Copyright (c) 2020 Johan Louwers.
# This program is free software: you can redistribute it and/or modify  
# it under the terms of the GNU General Public License as published by  
# the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License 
# along with this program. If not, see <http://www.gnu.org/licenses/>.
# ---------------------------------------------------------------------
#
#
# --EXPLANATION--------------------------------------------------------
# This script is used as a first boot script for an NGNIX web node. It
# will be started on the first boot and will do all the required steps
# to make a NGNIX web node from a standard Oracle Linux instance. By 
# using a first boot script method we do not have to maintain templates
# for each type of node we will be deploying and changes can be made in
# a quick fashion by changing the first boot script. 
# ---------------------------------------------------------------------
#
#
