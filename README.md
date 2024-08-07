# Buildkite-Monorepo-Example



[![Add to Buildkite](https://buildkite.com/button.svg)](https://buildkite.com/new)


The monorepo allows users to house multiple independent projects in one repository, giving you flexibility, easy management, and a simpler way to keep track of changes by watching folders

## Setup
To Get Started Fork the repository. Any directory in the repository can be watched  by specifying the `watch` attribute and its `path` in the pipeline configuration

See [**How to set up Continuous Integration for monorepo using Buildkite**](https://adikari.medium.com/set-up-continuous-integration-for-monorepo-using-buildkite-61539bb0ed76) for step-by-step instructions

<br/>

**Project Directories Structure**

```
├── .buildkite                          # Watch Folder
│   ├── pipelines                       # Watch Folder
├── app                                 # Watch Folder
|   ├── .buildkite                      # Watch Folder
│   ├── bin                             # Watch Folder
├── bin                                 # Watch Folder
├── test                                # Watch Folder
|   ├── .buildkite                      # Watch Folder
│   ├── bin                             # Watch Folder
├── .gitignore
└── README.md

```


**Requirement**
* Configure Webhooks in the Github Repository settings for your pipeline to subscribe to `Pushes`, `Deployments` and `Pull Requests` events. Can get the **Payload URL** from the pipeline's github settings setup instructions. If you don't have the permission, you'll need to get your repository admin to do this step. 




<br/>

## Using the monorepo-diff-buildkite-plugin
The  [**monorepo-diff buildkite plugin**](https://github.com/buildkite-plugins/monorepo-diff-buildkite-plugin), triggers pipelines by watching folders in the monorepo. The configuration supports running [Command](https://buildkite.com/docs/pipelines/command-step) and [Trigger](https://buildkite.com/docs/pipelines/trigger-step) steps

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
 
 
 * Changes to the path `app/` triggers the pipeline `app-deploy`
 * Changes to the path `test/bin` will run the respective configuration command
 
 <br/>
 
 ⚠️  Warning : The user has to explictly state the paths they want to monitor. For instance if a user,  is only watching path `app/` changes made to `app/bin` will trigger the configuration. This is because the subfolder `/bin` even though not specified, is still under the parent folder.
 
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
 
 * When changes are detected in the path `test/.buildkite/`  it triggers the pipeline `test-pipeline`
 * If the changes are made to either `app/` or `app/bin/service/` it triggers the pipeline `data-generator`
 

<br/>

## License

See [License.md](License.md) (MIT)

