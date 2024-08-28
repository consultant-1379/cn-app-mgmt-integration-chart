{{- define "eric-cn-app-mgmt-integration.product-info" }}
ericsson.com/product-name: "eric-cn-app-mgmt-integration"
ericsson.com/product-number: "CXC 201 2613"
ericsson.com/product-revision: {{ regexReplaceAll "(.*)[+].*" .Chart.Version "${1}" }}
{{- end }}
