EXTENSIONS=(
  dracula-theme.theme-dracula
  EliverLara.andromeda
  esbenp.prettier-vscode
  styled-components.vscode-styled-components
  PKief.material-icon-theme
  vscodevim.vim
  christian-kohler.npm-intellisense
  christian-kohler.path-intellisense
  EditorConfig.EditorConfig
  kshetline.ligatures-limited
  mariusschulz.yarn-lock-syntax
  mikestead.dotenv
  ms-azuretools.vscode-docker
  webben.browserslist
  yzhang.markdown-all-in-one
)
for EXTENSION in ${EXTENSIONS[@]}; do
  code --install-extension $EXTENSION
done