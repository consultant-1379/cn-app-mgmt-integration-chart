Cloud Native Application Manager Integration

===============

Cloud Native Application Manager (CN AM) is a set of core management services needed to life cycle manage cloud native workloads.
This set of services include pre-verified micro-services from the ADP marketplace. Different stakeholders might pick and choose different parts of 
the CN AM smorgasbord.


ADP Components
--------------
* eric-cloud-native-base
* eric-cnom-document-database-mg
* eric-cnom-server
* eric-lcm-container-registry
* eric-lcm-helm-chart-registry
* eric-lcm-helm-executor
* eric-sec-ldap-server

CNAM helmfile, integration chart, and eric-helm-file-executor?
-------------------------------------
You may install CN AM via helmfile, integration chart, or solely the microservice eric-lcm-helm-executor. The resources needed can be found here:

For the helmfile, see: **[helmfile](https://gerrit.ericsson.se/plugins/gitiles/OSS/com.ericsson.orchestration.mgmt/cn-app-mgmt-integration-chart/+/master/helmfile/)** directory

For the integration chart, see: **[eric-cn-app-mgmt-integration](https://gerrit.ericsson.se/plugins/gitiles/OSS/com.ericsson.orchestration.mgmt/cn-app-mgmt-integration-chart/+/master/eric-cn-app-mgmt-integration/)** 
directory

For the microservice, see: **[eric-helm-file-executor](https://adp.ericsson.se/marketplace/helmfile-executor)**



How to install CN AM integration chart?
-------------------------------------

### Prerequisites

####Create a clean namespace

Makes sure to have a tidied up namespace. You may delete and create the same namespace again. Makes sure nothing important is running in the 
namespace.

```shell script

# Delete namespace

kubectl delte namespace <NAMESPACE>

# Create namespace

kubectl create namespae <NAMESPACE>

```

####Edit ruleset2.0.yaml accordingly

You may find the ruleset2.0.yaml for the eric-cn-app-mgmt-integration here: **[ruleset2.0.yaml](https://gerrit.ericsson.se/plugins/gitiles/OSS/com.ericsson.orchestration.mgmt/cn-app-mgmt-integration-chart/+/master/ruleset2.0.yaml)**

### Installation


1.  Test if you can download the integration chart

    Download chart in helm/charts directory
    ```shell script
    wget https://arm.sero.gic.ericsson.se/artifactory/proj-bdgs-cn-app-mgmt-drop-helm/eric-cn-app-mgmt-integration/eric-cn-app-mgmt-integration-
    {chart_version}.tgz
    ```
2.  Edit requirements.yaml

    Add eric-cn-app-mgm-integration chart to your integration, i.e. requirements.yaml
    ```shell script
    dependencies:
    ...
    - name: eric-cn-app-mgmt-integration
      repository: https://arm.sero.gic.ericsson.se/artifactory/proj-bdgs-cn-app-mgmt-drop-helm/
      version: {chart_version}
    ...
    ```

3.  Edit values.yaml

    Add eric-cn-app-mgm-integration chart to your values.yaml
    ```shell script
    ...
    eric-cn-app-mgmt-integration:
      eric-lcm-helm-executor:
    ...
    ```

4.  Package the project

    In project root package the chart

    ```shell script
    helm package --dependency-update --version "<YOUR_CHART_VERSION>" --destination . <DIRECTORY_TO_REQUIREMENTS.YAML>
    ```

5.  Install package
    
    ```shell script
    helm upgrade --install <PROJECT_NAME> ./<PACKAGE_NAME> \
    --wait \
    --timeout 1800s \
    --namespace <NAMESPACE> \
    --values <PATH_TO_YOUR_VALUES.YAML> \
    --set global.pullSecret=regcred \
    --set global.imagePullSecret.registry=armdocker.rnd.ericsson.se \
    --set global.imagePullSecret.username=<USERNAME> \
    --set global.imagePullSecret.password=<PASSWORD> \
    --set eric-cn-app-mgmt-integration.eric-lcm-helm-executor.docker-registry.url=<DOCKER_REGISTRY_URL> \
    --set eric-cn-app-mgmt-integration.eric-lcm-helm-executor.docker-registry.username=<DOCKER_USER> \
    --set eric-cn-app-mgmt-integration.eric-lcm-helm-executor.docker-registry.password=<DOCKER_PASSWORD> \
    --set eric-cn-app-mgmt-integration.eric-lcm-helm-executor.helm-registry.url=<HELM_REGISTRY_URL> \
    --set eric-cn-app-mgmt-integration.eric-lcm-helm-executor.helm-registry.username=<HELM_USER> \
    --set eric-cn-app-mgmt-integration.eric-lcm-helm-executor.helm-registry.password=<HELM_PASSWORD> \
    --set eric-cn-app-mgmt-integration.eric-lcm-helm-executor.postgress.credentials.keyForUserId=<CUSTOM_USER> \
    --set eric-cn-app-mgmt-integration.eric-lcm-helm-executor.postgress.credentials.keyForUserPw=<CUSTOM_PASSWORD> \
    --set eric-cn-app-mgmt-integration.eric-lcm-helm-executor.ingress.hostname=<EXECUTOR_INGRESS_HOSTNAME>\
    --set eric-cn-app-mgmt-integration.eric-lcm-container-registry.registry.users.name=<DOCKER_USER> \
    --set eric-cn-app-mgmt-integration.eric-lcm-container-registry.registry.users.password=<DOCKER_PASSWORD> \
    --set eric-cn-app-mgmt-integration.eric-lcm-container-registry.ingress.hostname=<CONTAINER_REGISTRY_INGRESS_HOSTNAME> \
    --set eric-cn-app-mgmt-integration.eric-lcm-helm-chart-registry.env.secret.BASIC_AUTH_USER=<HELM_USER> \
    --set eric-cn-app-mgmt-integration.eric-lcm-helm-chart-registry.env.secret.BASIC_AUTH_PASS=<HELM_PASSWORD> \
    --set eric-cn-app-mgmt-integration.eric-lcm-helm-chart-registry.ingress.hostname=<HELM_REGISTRY_INGRESS_HOSTNAME> \
    --debug
    ```

6.  Watch pods

    In a new terminal
    ```shell script
    watch kubectl get pods -n <NAMESPACE>
    ```

How to install CN AM helmfile?
-------------------------------------

### Prerequisites

####Helmfile

Helmfile is a declarative spec for deploying helm charts.
Therefore, make sure that you have helmfile and the helm plugin installed.

#####Helmfile installation
1. Download helmfile
```shell script
Source: https://github.com/roboll/helmfile/releases
```
2. Create bin folder and move helmfile there, e.g.:
```shell script
mv helmfile_linux_amd64 ~/usr/bin/helmfile
chmod +x ~/usr/bin/helmfilele/releases
#make sure it is part of $PATH variable
```

3. Install helm plugin
```shell script
#check if helm plugin is available
helm plugin list
  sample output: 
      NAME	VERSION	DESCRIPTION                           
      diff	3.1.3  	Preview helm upgrade changes as a diff

#If not available
Download helm-diff from here: https://github.com/databus23/helm-diff/releases
Unzip to /home/$USER/.local/share/helm/plugins
#you may create /home/$USER/.local/share/helm/plugins directory first
#make sure that the unzipped directory is named "diff"

```

####Create a clean namespace

Makes sure to have a tidied up namespace. You may delete and create the same namespace again. Makes sure nothing important is running in the
namespace.

```shell script

# Delete namespace
kubectl delte namespace <NAMESPACE>

# Create namespace
kubectl create namespae <NAMESPACE>

```

####Edit ruleset2.0.yaml accordingly

You may find the ruleset2.0.yaml for the eric-cn-app-mgmt-integration here: **[ruleset2.0.yaml](https://gerrit.ericsson.se/plugins/gitiles/OSS/com.ericsson.orchestration.mgmt/cn-app-mgmt-integration-chart/+/master/ruleset2.0.yaml)**

### Installation

    
1.  Edit helmfile.yaml
    
    Edit your helmfile.yaml to your needs.
    You may compare it to **[CN AM Helmfile](https://gerrit.ericsson.se/plugins/gitiles/OSS/com.ericsson.orchestration.mgmt/cn-app-mgmt-integration-chart/+/refs/heads/master/helmfile/helmfile.yaml)**


2. Edit values.yaml

    Edit your values.yaml to your needs. 
    You may compare it to **[CN AM integration chart Values](https://gerrit.ericsson.se/plugins/gitiles/OSS/com.ericsson.orchestration.mgmt/cn-app-mgmt-integration-chart/+/refs/heads/master/eric-cn-app-mgmt-integration/values.yaml)** and **[CN AM Pipeline Values](https://gerrit.ericsson.se/plugins/gitiles/OSS/com.ericsson.orchestration.mgmt/cn-app-mgmt-integration-chart/+/refs/heads/master/Jenkinsinit/pipeline_values.yaml)**
   
    Make sure to set following values:
    ```shell script
   - eric-lcm-helm-executor.docker-registry.url
   - eric-lcm-helm-executor.docker-registry.username
   - eric-lcm-helm-executor.docker-registry.password
   - eric-lcm-helm-executor.helm-registry.url
   - eric-lcm-helm-executor.helm-registry.username
   - eric-lcm-helm-executor.helm-registry.password
   - eric-lcm-helm-executor.postgress.credentials.keyForUserId
   - eric-lcm-helm-executor.postgress.credentials.keyForUserPW
   - eric-lcm-helm-executor.ingress.hostname
   - eric-lcm-container-registry.registry.users.name
   - eric-lcm-container-registry.registry.users.password
   - eric-lcm-container-registry.ingress.hostname
   - eric-lcm-helm-chart-registry.env.secret.BASIC_AUTH_USER
   - eric-lcm-helm-chart-registry.env.secret.BASIC_AUTH_PASS
   - eric-lcm-helm-chart-registry.ingress.hostname
    ```


3.  Install helmfile.yaml

    ```shell script
    helmfile -f <PATH_TO_YOUR_HELMFILE.YAML> \
    --state-values-file <PATH_TO_YOUR_VALUES.YAML> \
    --state-values-set imagePullSecret.secretname=regcred \
    --state-values-set imagePullSecret.registry=armdocker.rnd.ericsson.se \
    --state-values-set imagePullSecret.username=<USERNAME> \
    --state-values-set imagePullSecret.password=<PASSWORD> \
    --namespace <NAMESPACE> \
    --debug apply
    ```

3.  Check pods
    
    In a new terminal
    ```shell script
    Helm -n <NAMESPACE> ls
    ```

How to install CN AM microservice eric-lcm-helm-executor?
-------------------------------------

Please refer to the documentation on ADP marketplace: **[eric-helm-file-executor](https://adp.ericsson.se/marketplace/helmfile-executor)**
