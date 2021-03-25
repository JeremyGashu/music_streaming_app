**This are helpfull informations for those who develop and participate on this 
project**

- We will have 2 branches, develop and master. where the master is the one that is going to be for release purposewhile the develop is for development purpose 
- When working on a feature, branch out from develop branch and name your new branch in the manner of "feature_..." 
for example - feature_authorization.

- We will also have a commit message standard so that it makes our agile 
process clear and all tests must be ran before a commit,for these to occur every developer should 
have a copy of the files under the git_hooks locally in the .git/hooks/.
In which the git_hooks folder is located on this projects root folder

- Our commit message standard is 

```bash
git commit -m " Feature Description... Fixes #21(Issue Number) "
```

Git flow should be used in order to control the work flow
Here is more on gitflow ->
https://docs.gitlab.com/ee/topics/gitlab_flow.html

