{{- /*
  Template: piwhelm.manifest.otherSecrets
  Renders standard Kubernetes secrets from values.yaml
  Usage: Only enabled secrets are rendered. Data is base64 encoded.
*/}}
{{- define "piwhelm.manifest.otherSecrets" }}
{{ $dict := (get .Values.global .Chart.Name )}}
{{ $secrets := $dict.secrets | required "Missing 'secrets' in values.yaml" }}
{{ $otherSecrets := $secrets.otherSecrets | default list }}
{{- range $otherSecrets }}
{{- if .enabled }}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ .name | default (printf "%s-secret" $.Chart.Name) }}
{{- include "metadata" $ | indent 2 }}
type: {{ .type | default "Opaque" }}
data:
  {{- range $key, $val := .data }}
    {{ $key }}: "{{ $val | b64enc }}"
  {{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- /*
  Template: piwhelm.manifest.externalSecrets
  Renders ExternalSecret resources from values.yaml
  Usage: Reads from values.yaml and creates ExternalSecret resources with standard structure.
*/}}
{{- define "piwhelm.manifest.externalSecrets" }}
{{ $dict := (get .Values.global .Chart.Name )}}
{{- if hasKey $dict "externalSecrets" }}
{{ $externalSecrets := $dict.externalSecrets }}
{{- range $externalSecrets }}
---
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ .name | required "Missing name in externalSecret" }}
  namespace: {{ .namespace | default $.Release.Namespace }}
{{- include "metadata" $ | indent 2 }}
spec:
  secretStoreRef:
    kind: {{ .kind | default "ClusterSecretStore" }}
    name: {{ .storeName | default "kubernetes" }}
  target:
    creationPolicy: Owner
  data:
    {{- range .data }}
    - secretKey: {{ .secretKey | required "Missing secretKey in externalSecret data" }}
      remoteRef:
        key: {{ .remoteRef.key | required "Missing remoteRef.key in externalSecret data" }}
        property: {{ .remoteRef.property | required "Missing remoteRef.property in externalSecret data" }}
    {{- end }}
{{- end }}
{{- end }}
{{- end }}
