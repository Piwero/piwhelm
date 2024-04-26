{{- define "piwhelm.containers" }}
{{- $containers := .deployment.containers }}
containers:
{{- range $containers }}
{{- if .enabled }}
  - name: {{ .name }}
    image: {{ .image }}
    imagePullPolicy: {{ .imagePullPolicy | default "IfNotPresent" }}
    {{- if .securityContext }}
    securityContext:
      {{- .securityContext | toYaml | nindent 8 -}}{{- end }}
    {{- if .ports }}
    ports:
    {{- range .ports }}
    - containerPort: {{ .containerPort }}
      name: {{ .name }}
      {{- if .protocol }}
      protocol: {{ .protocol }}{{- end }}
    {{- end }}
    {{- end }}
    {{- if .volumeMounts }}
    volumeMounts:
    {{- range .volumeMounts }}
      - name: {{ .name }}
        mountPath: {{ .mountPath }}
    {{- end }}
    {{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- define "piwhelm.envFrom" }}
{{- $configMap := .configMap }}
{{- $secrets := .secrets }}
{{- if or $configMap.enabled $secrets.otherSecrets }}
    envFrom:
{{- if $configMap.enabled }}
      - configMapRef:
          name: {{ $configMap.name }}
{{- end }}
{{- range $secrets.otherSecrets }}
      - secretRef:
          name: {{ .name }}
{{- end }}
{{- end }}
{{- end }}

{{- define "piwhelm.manifest.deployment" }}
{{ $dict := (get .Values.global .Chart.Name) }}
{{- $secrets := $dict.secrets }}
{{- $configMap := $dict.configMap }}
{{- $deployment := $dict.deployment }}
{{- if $deployment.enabled -}}
apiVersion: {{ $deployment.apiVersion }}
kind: Deployment
metadata:
  name: {{ $deployment.name | default (printf "%s-deploy" $.Chart.Name) }}
{{- include "metadata" $ | indent 2 }}
spec:
  replicas: {{ $deployment.replicas }}
  {{- include "selector" $ | indent 2 }}
  template:
    metadata:
      {{- include "labels" $ | indent 10 }}
    spec:
      {{- if $deployment.nodeSelector }}
      nodeSelector:
        {{- $deployment.nodeSelector | toYaml | nindent 10 }}
      {{- end }}
      {{- include "piwhelm.containers" (dict "deployment" $deployment) | nindent 6 }}
      {{- include "piwhelm.envFrom" (dict "configMap" $configMap "secrets" $secrets) | nindent 6 }}
      {{- if $deployment.volumes }}
      volumes:
        {{- range $deployment.volumes }}
        - name: {{ .name }}
          {{ if .emptyDir -}}
          emptyDir: {}
          {{- else -}}
          persistentVolumeClaim:
            claimName: {{ .persistentVolumeClaim }}
          {{- end }}
        {{- end }}
      {{- end }}
      {{- if $secrets.imageCredentials.enabled }}
      imagePullSecrets:
        - name: {{ $secrets.imageCredentials.name }}
      {{- end }}
{{- end }}
{{- end }}