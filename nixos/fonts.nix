{pkgs, ...}: {
  fonts.packages = with pkgs; [
    nerdfonts

    fira-code
    fira-code-symbols

    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji

    dina-font
    proggyfonts
    liberation_ttf
    mplus-outline-fonts.githubRelease
  ];
}
