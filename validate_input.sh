#Validating clustername in scripts used in Microservices Repo.
function validateClusterName() {
    clustername_base_string=""
    kubecfgcluster=""
    if [[ $CLOUD = "azure" ]]; then
        clustername_base_string=""
        kubecfgcluster=$(kubectl config get-contexts  | grep "*" | awk '{ print $2 }')
    else
        clustername_base_string="config-"
        kubecfgcluster=`basename $KUBECONFIG`
    fi
    if [ -z "$1" ]
    then
        read -p 'Provide the cluster name: ' readname
        clusterconfig="${clustername_base_string}${readname}"
        CLUSTERNAME=${readname}
    else 
        clusterconfig="${clustername_base_string}${1}"
    fi 
    if [ "$kubecfgcluster" != "$clusterconfig" ]
    then
            echo "${kubecfgcluster} and ${clusterconfig} are same ?"
            echo "Mismatch in cluster name with KUBECONFIG, please set KUBECONFIG correctly."
            exit 1
    fi
}

#Validating environment in scripts used in Microservices Repo
function validateEnv() {
    if [ -z "$ENV" ]
    then
        read -p 'Environment : choose 1 for production, 2 for qa and 3 for development: ' readenv

        if  [ "$readenv" -eq "$readenv" ] 2> /dev/null ; then
            if [ $readenv -lt 1 -o $readenv -gt 3 ]; then 
                echo -e "\n ----- Enter a number between 1 and 3 -----"
            elif [ $readenv -eq 1 ]; then
                ENV="production"
            elif [ $readenv -eq 2 ]; then
                ENV="qa"
            elif [ $readenv -eq 3 ]; then
                ENV="development"
            fi
        else 
            echo -e "\n -----Input is not valid -----"
            echo -e "Exiting"
            exit 1
        fi 
    fi
}

#Validating revision in scripts used in Microservices Repo
function validateRevision() {
    echo "revision is --> ${REVISION}"
    if [ -z "$REVISION" ]
    then
        read -p 'Provide Release Version: ' REVISION
        if [ -z "$REVISION" ]
        then 
            echo "No Revision is provided. Exiting"
            exit 1
        fi
        echo "Using revision as ${REVISION}"
    fi
}

#Validating revision in scripts used in Microservices Repo
function validateCloud() {
    echo "Cloud is --> ${CLOUD}"
    if [ -z "${CLOUD}" ]
    then
        read -p 'Provide CLOUD: ' CLOUD
        if [ -z "$CLOUD" ]
        then 
            echo "No CLOUD is provided. Exiting"
            exit 1
        fi
        echo "Using CLOUD as ${CLOUD}"
    fi
}

function setClusterName() {
    if [ ! -z $1 ];
    then
        export CLUSTERNAME=$1
    fi

}

function setRevision() {
    if [ ! -z $1 ];
    then
        export REVISION=$1
    fi
}

function setCloud() {
    if [ ! -z $1 ];
    then
        export CLOUD=$1
    fi
}

function setEnv() {
    if [ ! -z $1 ];
    then
        export ENV=$1
    fi
}

echo "Setting environment Variables"
setClusterName $2
setRevision $3
setEnv $4
setCloud $5

echo "Validating inputs"
validateClusterName $CLUSTERNAME
validateRevision ${REVISION}
validateEnv ${ENV}
validateCloud ${CLOUD}


echo "Cluster Name : ${CLUSTERNAME}"
echo "Revision to deploy : ${REVISION}"
echo "Profile to deploy : ${ENV}"
echo "Cloud to deploy : ${CLOUD}"
