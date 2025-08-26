{{- /*
  Template: piwhelm.manifest.secretImagePull
  Renders a Docker image pull secret if enabled in values.yaml
  Usage: Uses imageCredentials values and encodes dockerconfigjson
*/}}
{{- define "piwhelm.manifest.secretImagePull" }}
{{ $dict := (get .Values.global .Chart.Name )}}
{{ $secrets := $dict.secrets | required "Missing 'secrets' in values.yaml" }}
{{ $imageCreds := $secrets.imageCredentials | required "Missing 'imageCredentials' in secrets" }}
{{ if $imageCreds.enabled }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ $imageCreds.name | required "Missing imageCredentials.name" }}
{{- include "metadata" . | indent 2 }}
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: {{ template "imagePullSecret" . }}
{{- end }}
{{- end }}

{{- /*
  Template: imagePullSecret
  Encodes docker registry credentials for image pull secret
*/}}
{{- define "imagePullSecret" -}}
{{- $dict := (get .Values.global .Chart.Name ) -}}
{{- $secrets := $dict.secrets -}}
{{- $imageCreds := $secrets.imageCredentials -}}
{{- if $imageCreds.enabled -}}
{{- with $imageCreds -}}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password .email (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end -}}
{{- end -}}
{{- end -}}
