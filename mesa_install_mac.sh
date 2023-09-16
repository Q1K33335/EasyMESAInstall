#! /bin/bash
if [[ -t 1 ]]; then
  tty_escape() { printf "\033[%sm" "$1"; }
else
  tty_escape() { :; }
fi
tty_universal() { tty_escape "0;$1"; } #正常显示
tty_mkbold() { tty_escape "1;$1"; } #设置高亮
tty_underline="$(tty_escape "4;39")" #下划线
tty_blue="$(tty_universal 34)" #蓝色
tty_red="$(tty_universal 31)" #红色
tty_green="$(tty_universal 32)" #绿色
tty_yellow="$(tty_universal 33)" #黄色
tty_bold="$(tty_universal 39)" #加黑
tty_cyan="$(tty_universal 36)" #青色
tty_reset="$(tty_escape 0)" #去除颜色

MACHINE="$(uname -m)"
if [ "${MACHINE}" == "arm64" ]; then
    MACHINE_DIR_TYPE="mesasdk_m"
else
    MACHINE_DIR_TYPE="mesasdk_i"
fi

# Main
# Program Detail
echo "${tty_green}      MESA Auto Installer Offline(MESA_PAK Installer)
        Version: 1.0
        for MacOS Intel/Apple Silicon
        Default(One Click) Mode${tty_reset}"

echo "${tty_yelow}Continue? (y/n)${tty_reset}"
read -r CONTINUE
if [ "$CONTINUE" == "n" ]; then
    echo "${tty_red}Exit...${tty_reset}"
    exit
    fi

# Read MESA_PAK DIR
echo "${tty_green}Please input MESA_PAK DIR:${tty_reset}"
read -r MESAPAK_DIR
chmod -R 777 ${MESAPAK_DIR}

# Install requirements
echo "${tty_blue}Step 1: Install requirements...
    ${tty_reset}"
echo "${tty_blue}==> Please Install XQuartZ${tty_reset}"

echo "${tty_blue}==> Install XCode Command Line Tools${tty_reset}"
echo "${tty_reset}==> Execute: xcode-select --install"
xcode-select --install

# Copy files
echo "${tty_blue}Step 2: Copy files...
    ${tty_reset}"
echo "${tty_blue}==> Copy MESA SDK...${tty_reset}"
echo "${tty_reset}==> Execute: cp -r ${MESAPAK_DIR}/${MACHINE_DIR_TYPE} /Applications/mesasdk"
cp -r ${MESAPAK_DIR}/${MACHINE_DIR_TYPE} /Applications/mesasdk

echo "${tty_blue}==> Copy MESA Sources...${tty_reset}"
echo "${tty_reset}==> Execute: cp -r ${MESAPAK_DIR}/mesa ~/mesa"
cp -r ${MESAPAK_DIR}/mesa ~/mesa

# Set Environment
echo "${tty_blue}Step 3: Set Environment...
    ${tty_reset}"
echo "${tty_blue}==> Set MESA Environment...${tty_reset}"
echo "${tty_reset}==> Execute: echo -e "# set MESA_DIR to be the directory to which you downloaded MESA\nexport MESA_DIR=~/mesa\n# you should have done this when you set up the MESA SDK\nexport MESASDK_ROOT=/Applications/mesasdk\nsource $MESASDK_ROOT/bin/mesasdk_init.sh" >> ~/.zshrc"
echo -e "# set MESA_DIR to be the directory to which you downloaded MESA\nexport MESA_DIR=~/mesa\n# you should have done this when you set up the MESA SDK\nexport MESASDK_ROOT=/Applications/mesasdk\nsource $MESASDK_ROOT/bin/mesasdk_init.sh" >> ~/.zshrc
echo "${tty_reset}==> Execute: source ~/.zshrc"
source ~/.zshrc

# Compile MESA
echo "${tty_blue}Step 4: Compile MESA...
    ${tty_reset}"
echo "${tty_reset}==> Execute: cd ${MESA_DIR}"
cd ${MESA_DIR}
echo "${tty_reset}==> Execute: ./install"
echo "${tty_cyan}==> Please wait..."
./install
