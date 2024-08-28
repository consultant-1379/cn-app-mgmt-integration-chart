{{- define "eric-cn-app-mgmt-integration.executor-container-creds" -}}
{{- $executor := index .Values "eric-lcm-helm-executor" "container-registry" -}}
{{- if $executor.credentials.kubernetesSecretName -}}
{{- print $executor.credentials.kubernetesSecretName -}}
{{- else -}}
{{- include "eric-cn-app-mgmt-integration.name" . -}}-docker-creds
{{- end -}}
{{- end -}}

{{- define "eric-cn-app-mgmt-integration.MinioSecretName" -}}
{{- print "eric-data-object-storage-mn" -}}
{{- end -}}

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "eric-cn-app-mgmt-integration.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create version
*/}}
{{- define "eric-cn-app-mgmt-integration.version" -}}
{{- printf "%s" .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "eric-cn-app-mgmt-integration.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Expand the Lcm DB connection type
*/}}
{{- define "eric-cn-app-mgmt-integration.dbconntype" -}}
{{- $dbconntype := index .Values "eric-lcm-helm-executor" -}}
{{- print $dbconntype.postgresql.ssl -}}
{{- end -}}

{{/*
Expand credential for eric-lcm-container-registry
*/}}
{{- define "eric-cn-app-mgmt-integration.lcmregistry" -}}
{{- if index .Values "eric-lcm-container-registry" "enabled" -}}
{{- $RegistrySecret := index .Values "eric-lcm-container-registry" -}}
  {{- if $RegistrySecret.registry.users.secret  -}}
    {{- print $RegistrySecret.registry.users.secret -}}
  {{- else -}}
    {{- include "eric-cn-app-mgmt-integration.name" . -}}-lcmregistry
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Expand credential for eric-lcm-container-registry
*/}}
{{- define "eric-cn-app-mgmt-integration.lcmregistrycred" -}}
{{ if index .Values "eric-lcm-container-registry" "enabled" }}
{{- $RegistryUserPass := index .Values "eric-lcm-container-registry" -}}
{{ htpasswd $RegistryUserPass.registry.users.name $RegistryUserPass.registry.users.password  | b64enc | quote }} 
{{- end -}}
{{- end -}}

{{/*
Expand the name of the tls secret for eric-lcm-container-registry
*/}}
{{- define "eric-cn-app-mgmt-integration.lcmTlsSecretContainerRegistry" -}}
{{- if index .Values "eric-lcm-container-registry" "ingress" "tls" "secretName" -}}
{{- index .Values "eric-lcm-container-registry" "ingress" "tls" "secretName" -}}
{{- else -}}
{{- include "eric-cn-app-mgmt-integration.name" . -}}-container-registry-tls
{{- end -}}
{{- end -}}

{{/*
Expand the name of the tls secret for eric-lcm-helm-chart-registry
*/}}
{{- define "eric-cn-app-mgmt-integration.lcmTlsSecretHelmChartRegistry" -}}
{{- if index .Values "eric-lcm-helm-chart-registry" "ingress" "tls" "secretName" -}}
{{- index .Values "eric-lcm-helm-chart-registry" "ingress" "tls" "secretName" -}}
{{- else -}}
{{- include "eric-cn-app-mgmt-integration.name" . -}}-helm-chart-registry-tls
{{- end -}}
{{- end -}}

{{/*
Generate certificates for eric-lcm-container-registry
*/}}
{{- define "eric-cn-app-mgmt-integration.gen-container-registry-certs" -}}
{{- $fqdn := index .Values "eric-lcm-container-registry" "ingress" "hostname" -}}
{{- $cert := genSelfSignedCert $fqdn nil ( list $fqdn ) 365 -}}
tls.crt: {{ $cert.Cert | b64enc }}
tls.key: {{ $cert.Key | b64enc }}
{{- end -}}

{{/*
Generate certificates for eric-lcm-helm-chart-registry
*/}}
{{- define "eric-cn-app-mgmt-integration.gen-helm-chart-registry-certs" -}}
{{- $fqdn := index .Values "eric-lcm-helm-chart-registry" "ingress" "hostname" -}}
{{- $cert := genSelfSignedCert $fqdn nil ( list $fqdn ) 365 -}}
tls.crt: {{ $cert.Cert | b64enc }}
tls.key: {{ $cert.Key | b64enc }}
{{- end -}}
