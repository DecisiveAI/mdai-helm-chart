{{- define "valkey.valkeyURI" -}}
  {{- $sentinels := list -}}
  {{- range $i := until (int .Values.valkey.replica.replicaCount) }}
    {{- $sentinels = append $sentinels (printf "%s-valkey-node-%d.%s-valkey-headless.%s.svc.cluster.local:%d" $.Release.Name $i $.Release.Name $.Release.Namespace (int $.Values.valkey.sentinel.service.ports.sentinel)) }}
  {{- end }}

  {{- if gt (len $sentinels) 0 }}
    {{- $base := first $sentinels -}}
    {{- $query := list -}}
    {{- range rest $sentinels }}
      {{- $query = append $query (printf "addr=%s" .) }}
    {{- end }}
    {{- printf "redis://%s?%s&master_set=%s" $base ($query | join "&") $.Values.valkey.sentinel.primarySet -}}
  {{- else }}
    {{- printf "redis://localhost:26379" -}}
  {{- end }}
{{- end }}