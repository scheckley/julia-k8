# julia-k8

Experimental Dockerfile to build a Julia Pluto environment on an Openshift cluster.

ToDo:

- [ ] Fix permissions error

```
ERROR: InitError: IOError: open("/home/juliauser/.julia_custom_depot/logs/manifest_usage.toml.pid", 194, 292): permission denied (EACCES)
Stacktrace:
```
Seems related to this issue:
- <https://github.com/JuliaLang/julia/issues/30608>
