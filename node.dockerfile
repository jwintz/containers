## Version: $Id:  $
## 
## 

## Commentary:
## 
## 

## Changelog:
## 
## 

## 
## Code starts here
## #############################################################################

FROM base:latest

RUN apk add nodejs
RUN apk add npm
RUN apk add yarn

ENV NODE_ENV=development \
    NPM_CONFIG_UPDATE_NOTIFIER=false \
    NPM_CONFIG_FUND=false

RUN mkdir -p /workspace

WORKDIR /workspace

RUN echo '' >> /etc/zsh/zshrc && \
    echo '# Node.js aliases' >> /etc/zsh/zshrc && \
    echo 'alias ni="npm install"' >> /etc/zsh/zshrc && \
    echo 'alias nr="npm run"' >> /etc/zsh/zshrc && \
    echo 'alias ns="npm start"' >> /etc/zsh/zshrc && \
    echo 'alias nt="npm test"' >> /etc/zsh/zshrc && \
    echo 'alias nb="npm run build"' >> /etc/zsh/zshrc && \
    echo 'alias nd="npm run dev"' >> /etc/zsh/zshrc && \
    echo 'alias yi="yarn install"' >> /etc/zsh/zshrc && \
    echo 'alias ys="yarn start"' >> /etc/zsh/zshrc && \
    echo 'alias yt="yarn test"' >> /etc/zsh/zshrc && \
    echo 'alias yb="yarn build"' >> /etc/zsh/zshrc && \
    echo 'alias yd="yarn dev"' >> /etc/zsh/zshrc && \
    echo 'alias pi="pnpm install"' >> /etc/zsh/zshrc && \
    echo 'alias pr="pnpm run"' >> /etc/zsh/zshrc && \
    echo 'alias ps="pnpm start"' >> /etc/zsh/zshrc && \
    echo 'alias pt="pnpm test"' >> /etc/zsh/zshrc && \
    echo 'alias pb="pnpm build"' >> /etc/zsh/zshrc && \
    echo 'alias pd="pnpm dev"' >> /etc/zsh/zshrc

RUN echo '{}' > /workspace/package.json

## #############################################################################
## Code ends here
