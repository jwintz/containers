```sh
defaults write com.apple.container.defaults build.rosetta -bool false
```

```sh
container builder delete
container builder start
```

```sh
container build --tag base --file base.dockerfile build
container build --tag node --file node.dockerfile build
container images ls -a
container ls -a
container run -it --rm base
container run -it --rm node
```
