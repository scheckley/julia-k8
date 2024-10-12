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

The security context required by OpenShift on a shared cluster are too restrictive for a Pluto deployment. This will need to wait until some future where Julia sorts out the way Pkg works expecting to be able to install dependencies anywhere it likes. Needs proper virtualisation.
