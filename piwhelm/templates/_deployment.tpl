{{- define "piwhelm.manifest.deployment" }}
{{ $dict := (get .Values.global .Chart.Name) }}
{{- $secrets := $dict.secrets }}
{{- $deployment := $dict.deployment }}
{{- $containers := $deployment.containers }}
{{- if $deployment.enabled -}}
apiVersion: {{ $deployment.apiVersion }}
kind: {{ $deployment.kind }}
metadata:
  name: {{ $deployment.name | default (printf "%s-deploy" $.Chart.Name) }}
  replicas: {{ $deployment.replicas }}
{{- include "metadata" $ | indent 2 }}
{{- include "selector" $ | indent 2 }}
template:
    metadata:
        labels:
{{- include "metadata" $ | indent 8 }}
spec:
{{- if $deployment.nodeSelector }}
  nodeSelector:
    {{- $deployment.nodeSelector | toYaml | nindent 10 }}
 {{- end }}
{{- end }}
{{- if $deployment.enabled }}
  containers:
{{- range $containers }}
{{- if .enabled }}
      - name: {{ .name }}
        image: {{ .image }}
        imagePullPolicy: {{ .imagePullPolicy | default "IfNotPresent" }}
{{- if .securityContext }}
        securityContext:
          {{- .securityContext | toYaml | nindent 10 -}}{{- end }}
{{- end }}
{{- if .envFrom }}
        envFrom:
          {{- .envFrom | toYaml | nindent 10 -}}{{- end }}
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
              mountPath: {{ .mountPath }}{{- end }}
        {{- end }}
        {{- end }}
     {{- if $deployment.volumes }}
     {{- $volumes := $deployment.volumes }}
        volumes:
        {{- range $volumes }}
            - name: {{ .name}}
              {{ if .emptyDir -}}
              emptyDir: {}
              {{- else -}}
              persistentVolumeClaim: {{ .persistentVolumeClaim  }}{{- end }}
              {{- end -}}
        {{- end }}

    {{- if $secrets.imageCredentials.enabled }}
        imagePullSecrets:
            - name: {{ $secrets.imageCredentials.name }}{{- end }}
    {{- end }}
{{- $otherSecrets := $secrets.otherSecrets }}
{{- if $otherSecrets }}
        env:
{{- range $otherSecrets }}
        - name: {{ .name }}
          valueFrom:
            secretKeyRef:
              {{- range $key, $val := .data }}
              name: {{ $key }}
              key: {{ $key }}{{- end }}
        {{- end }}
    {{- if $secrets.imageCredentials.enabled }}
        imagePullSecrets:
            - name: {{ $secrets.imageCredentials.name }}{{- end }}
    {{- end }}
    {{- end }}

