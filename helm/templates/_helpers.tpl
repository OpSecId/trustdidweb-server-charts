{{- define "global.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "global.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "global.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "common.labels" -}}
app: {{ include "global.name" . }}
helm.sh/chart: {{ include "global.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{- define "common.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/* SERVER */}}

{{- define "server.fullname" -}}
{{ template "global.fullname" . }}
{{- end -}}

{{- define "server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "server.fullname" . }}
{{ include "common.selectorLabels" . }}
{{- end -}}

{{- define "server.labels" -}}
{{ include "common.labels" . }}
{{ include "server.selectorLabels" . }}
{{- end -}}

{{- define "server.openshift.route.tls" -}}
insecureEdgeTerminationPolicy: {{ .Values.openshift.route.tls.insecureEdgeTerminationPolicy }}
termination: {{ .Values.openshift.route.tls.termination }}
{{- end -}}

{{/* POSTGRESQL */}}
{{- define "global.postgresql.fullname" -}}
{{- if .Values.postgresql.fullnameOverride }}
{{- .Values.postgresql.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $postgresContext := dict "Values" .Values.postgresql "Release" .Release "Chart" (dict "Name" "postgresql") -}}
{{ template "postgresql.primary.fullname" $postgresContext }}
{{- end -}}
{{- end -}}

{{- define "postgresql.selectorLabels" -}}
app.kubernetes.io/name: {{ include "global.postgresql.fullname" . }}
{{ include "common.selectorLabels" . }}
{{- end -}}

{{- define "postgresql.labels" -}}
{{ include "common.labels" . }}
{{ include "postgresql.selectorLabels" . }}
{{- end -}}