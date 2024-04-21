{{- define "piwhelm.manifest.secrets" }}
{{- $dict := (get .Values.global .Chart.Name ) -}}
{{- $secrets := $dict.secrets -}}
{{- if hasKey ($secrets "imageCredentials" )}}
{{- if $secrets.imageCredentials.enabled -}}
{{- include "imageCredentialsSecret" . -}}
{{- end }}
{{- end }}
{{- end }}



{{- define "imageCredentialsSecret" -}}
{{- $dict := (get .Values.global .Chart.Name ) -}}
{{- $secrets := $dict.secrets -}}
{{- if $secrets.imageCredentials.enabled -}}
{{- $dict := (get .Values.global .Chart.Name ) -}}
{{- $secrets := $dict.secrets -}}
{{- if $secrets.imageCredentials.enabled -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ $secrets.imageCredentials.name }}
{{- end }}
{{- include "metadata" . | indent 2 }}
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: {{ template "imagePullSecretCredentials" . }}
{{- end }}
{{- end -}}

{{- define "imagePullSecretCredentials" -}}
{{- $dict := (get .Values.global .Chart.Name ) -}}
{{- $secrets := $dict.secrets -}}
{{- if $secrets.imageCredentials.enabled -}}
{{- with $secrets.imageCredentials -}}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password .email (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end -}}
{{- end -}}
{{- end -}}