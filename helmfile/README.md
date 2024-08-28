# CN AM Helmfile

This folder contains all the files to deploy CN AM using a Helmfile.


```

helmfile -e <env-name> -f helmfile.yaml -n <namespace> apply

helmfile -e <env-name> -f helmfile.yaml -n <namespace> destroy

```

-e the environment to use, which are listed in the environments.yaml file.
-f the root helmfile
-n the namespace to deploy into

The environment references the values files which are in the `env-profiles` folder.

Please see the prerequisites section of the README.md file at the root of the repository for prerequisites required
 for these services.