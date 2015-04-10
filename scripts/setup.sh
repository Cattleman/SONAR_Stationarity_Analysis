# setup.sh
#
# Usage: source scripts/setup.sh
#

#function
msg() {
echo "Script: $0 - $*"
}


msg "Configuring the env"

# for MacOS
# code path
#export ANALYSISWORKSPACE="/Users/natmourajr/Documents/Work/UFRJ/Doutorado/workspace/Marinha/SONAR_SVMNoveltyDetection"

# input data path
#export INPUTDATAPATH="/Users/natmourajr/Documents/Work/UFRJ/Doutorado/workspace/Marinha/Data/Classificacao/4Class/Audio"

# outputh data path
#export OUTPUTDATAPATH="/Users/natmourajr/Documents/Work/UFRJ/Doutorado/workspace/Marinha/SONAR_SVMNoveltyDetection/Data"


# for LPS account

# code path
export ANALYSISWORKSPACE="/home/natmourajr/Documents/Doutorado/workspace/Marinha/SONAR_Stationarity_Analysis"

# input data path
export INPUTDATAPATH="/home/natmourajr/Documents/Doutorado/workspace/Marinha/Data/Classificacao/4Class/Audio"

# outputh data path
export OUTPUTDATAPATH="/home/natmourajr/Documents/Doutorado/workspace/Marinha/SONAR_Stationarity_Analysis/Data"

msg "Code Path: " $ANALYSISWORKSPACE
msg "Input Data Path: " $INPUTDATAPATH
msg "Output Data Path: " $OUTPUTDATAPATH


msg "Configuration Done!!!"
