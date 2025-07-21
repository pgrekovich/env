EXTENSIONS=(
  dracula-theme.theme-dracula
  EditorConfig.EditorConfig
  GitHub.copilot
  kshetline.ligatures-limited
  ms-azuretools.vscode-docker
  ms-vscode-remote.remote-containers
  ms-vscode-remote.remote-ssh
  ms-vscode-remote.remote-ssh-edit
  ms-vscode-remote.vscode-remote-extensionpack
  ms-vscode.remote-explorer
  ms-vscode.remote-server
  PKief.material-icon-theme
  TomRijndorp.find-it-faster
  vscodevim.vim
  yzhang.markdown-all-in-one
)
for EXTENSION in ${EXTENSIONS[@]}; do
  code --install-extension $EXTENSION
done
