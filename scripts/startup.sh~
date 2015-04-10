# startup.sh
#
# Usage: source scripts/startup.sh

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
export INPUTDATAPATH="/home/natmourajr/Documents/Doutorado/workspace/Marinha/Data/Classificacao/4Class/Audio/"

# outputh data path
export OUTPUTDATAPATH="/home/natmourajr/Documents/Doutorado/workspace/Marinha/SONAR_Stationarity_Analysis/Data"

msg "Code Path: " $ANALYSISWORKSPACE
msg "Input Data Path: " $INPUTDATAPATH
msg "Output Data Path: " $OUTPUTDATAPATH


msg "Configuration Done!!!"

msg "Removing Analysis Data Folder"
rm -rf "$OUTPUTDATAPATH"

msg "Creating a new Folder Struct"
mkdir "$OUTPUTDATAPATH"

mkdir "$OUTPUTDATAPATH/mat"
mkdir "$OUTPUTDATAPATH/mat/pca"
mkdir "$OUTPUTDATAPATH/mat/pcd"
#mkdir "$OUTPUTDATAPATH/mat/stationarity"

mkdir "$OUTPUTDATAPATH/audio"

mkdir "$OUTPUTDATAPATH/pict"
mkdir "$OUTPUTDATAPATH/pict/pca"
mkdir "$OUTPUTDATAPATH/pict/pcd"
mkdir "$OUTPUTDATAPATH/pict/stationarity"
mkdir "$OUTPUTDATAPATH/pict/sonar"

cd "$ANALYSISWORKSPACE"

msg "End"
