# Buildkite-Monorepo-Example



[![Add to Buildkite](https://buildkite.com/button.svg)](https://buildkite.com/new)


The monorepo, serves as a unified, version-controlled repository that houses multiple independent projects, giving you flexibility, easy management, and a simpler way to keep track of changes and dependencies across different repositories.

* Reduce overhead associated with duplicating code for microservices.
* Easily maintain and monitor the code


<br/>  

## User Manual

Create Folders and/or Sub folders in the repository to watch, we will be using `app/` and `test/` folders

```
├── .buildkite
│   ├── pipelines
├── app
|   ├── .buildkite
│   ├── bin
├── bin
├── test
|   ├── .buildkite
│   ├── bin
├── .gitignore
└── README.md

```

#### Webhooks

Configure Webhooks in the Github Repository settings for your pipeline to subscribe to `Pushes`, `Deployments` and `Pull Requests` events. You must be a repository owner or have admin access in the repository to create webhooks.



#### monorepo-diff-buildkite-plugin
We would be using the buildkite monorepo-diff plugin, it will assist in triggering pipelines by watching folders in the monorepo. The configuration supports running [Command](https://buildkite.com/docs/pipelines/command-step) or [Triggering](https://buildkite.com/docs/pipelines/trigger-step)

The user has to explictly state the paths they want to monitor. For example if a user specifies `app/` as the path and changes are made to `app/bin` it will not trigger the config because the subfolder was not specified.


<br/>

**Example 1**
<br/>

```yaml
steps:
  - label: "Triggering pipelines"
    plugins:
      - buildkite-plugins/monorepo-diff#v1.0.1:
          diff: "git diff --name-only HEAD~1"
          watch:
            - path: app/
              config:
                trigger: "app-deploy"
            - path: test/bin/
              config:
                command: "echo Make Changes to Bin"
```


* Changes to the path `app/` triggers the the pipeline `app-deploy`
* Changes to the path `test/bin` will run the respectively config command

<br/>

See [**How to set up Continuous Integration for monorepo using Buildkite**](https://adikari.medium.com/set-up-continuous-integration-for-monorepo-using-buildkite-61539bb0ed76) for step-by-step instructions on how to get this running


<br/>

 **Example 2**
 <br/>
    

```yaml
    steps:
      - label: "Triggering pipelines with plugin"
        plugins:
          - buildkite-plugins/monorepo-diff#v1.0.1:
             watch:           
              - path: test/.buildkite/
                config: # Required [trigger step configuration]
                  trigger: test-pipeline # Required [trigger pipeline slug]
              - path:
                  - app/
                  - app/bin/service/
                config:
                    trigger: "data-generator"
                    label: ":package: Generate data"
                    build:
                      meta_data:
                        release-version: "1.1"
```

* When changes are detected in the path `test/.buildkite/`  it triggers the the pipeline `test-pipeline`
* If the changes are made to either `app/` or `app/bin/service/` it triggers `data-generator`


<br/>

## License

See [License.md](License.md) (MIT)

