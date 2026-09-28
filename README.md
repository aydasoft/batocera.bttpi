# Batocera BTT-Pi / CB1 da BIGTREETECH

[![Batocera](https://img.shields.io/badge/Batocera-44-blue)](https://batocera.org/)
[![Platform](https://img.shields.io/badge/Platform-Allwinner%20H616-orange)](#hardware-alvo)
[![Board](https://img.shields.io/badge/Board-CB1%20%2F%20BTTPi-green)](#hardware-alvo)
[![Status](https://img.shields.io/badge/Status-Experimental-yellow)](#status-do-projeto)

Fork do **Batocera Linux** com suporte ao **BTT-Pi / CB1**, baseado no SoC **Allwinner H616**.

> [!WARNING]
> Este é um port **não oficial** do Batocera.  
> Use por sua conta e risco. Recursos ainda podem estar incompletos ou mudar entre versões.

---

## Hardware alvo

Este port é direcionado ao hardware **BTT-Pi / CB1**.

| Componente | Hardware |
|---|---|
| SoC | Allwinner H616 |
| CPU | ARM64 |
| GPU | Mali G31 |
| Plataforma | CB1 / BTTPi |
| Wi-Fi | RTL8189FS / RTL8188F |
| Vídeo | HDMI |
| Sistema | Batocera Linux 44 |

---

## Status do projeto

O port está em desenvolvimento ativo.

| Recurso | Estado |
|---|---|
| Target Batocera para H616 / CB1 | ✅ Implementado |
| Geração da imagem | ✅ Implementado |
| Boot específico do CB1 | ✅ Implementado |
| Overlay do sistema | ✅ Implementado |
| Configuração de kernel específica | ✅ Implementado |
| Driver RTL8189FS / RTL8188F | ✅ Integrado |
| Recuperação automática do Wi-Fi | ✅ Integrada |
| Patch SD / HDMI para H616 | ✅ Integrada |
| HDMI | ✅ Integrada |
| Áudio | ✅ Integrada |
| GPU / aceleração gráfica | ✅ Integrada |
| Estabilidade geral | 🧪 Em testes |

---

## Principais alterações

Os principais arquivos estão em:

```text
board/batocera/allwinner/h616/cb1-poc/
```

Incluindo:

```text
boot/boot.cmd
boot/extlinux.conf
create-boot-script.sh
fsoverlay/etc/init.d/S90cb1-poc
fsoverlay/etc/init.d/S95cb1-wifi-recover
fsoverlay/etc/modules.conf
genimage.cfg
linux.config.fragment
```

### Definição da placa

```text
configs/batocera-h616-cb1.board
```

### Patch H616

Foi adicionado um patch específico para a plataforma:

```text
board/batocera/allwinner/h616/linux_patches/cb1-poc-sd-hdmi.patch
```

A série de patches H616 também foi atualizada para incluí-lo.

---

## Wi-Fi RTL8189FS / RTL8188F

O CB1 utiliza uma variante do chip Realtek que exige alterações específicas no driver `rtl8189fs`.

Essas alterações são mantidas no fork do Buildroot:

**https://github.com/aydasoft/buildroot**

Entre as modificações estão:

- seleção de uma versão do driver compatível com RTL8188F;
- flags específicas para o módulo;
- integração condicionada ao suporte Wi-Fi do CB1;
- hash da fonte utilizada pelo Buildroot;
- script de recuperação do Wi-Fi durante a inicialização.

O script incluído no sistema é:

```text
S95cb1-wifi-recover
```

---

## Buildroot customizado

Este projeto usa um fork próprio do Buildroot porque parte do suporte ao BTTPi precisa existir dentro do submódulo.

Repositório:

```text
https://github.com/aydasoft/buildroot.git
```

Branch de desenvolvimento:

```text
bttpi
```

O repositório principal mantém o commit correto do Buildroot através do submódulo Git.

---

## Clonando o projeto

Clone o repositório incluindo os submódulos:

```bash
git clone --recursive https://github.com/aydasoft/batocera.bttpi.git
cd batocera.bttpi
```

Se o repositório já tiver sido clonado sem `--recursive`:

```bash
git submodule update --init --recursive
```

Para conferir o commit usado pelo Buildroot:

```bash
git submodule status
```

---

## Atualizando um clone existente

Atualize o repositório principal:

```bash
git pull
```

Depois sincronize e atualize os submódulos:

```bash
git submodule sync --recursive
git submodule update --init --recursive
```

---

## Build

O target do projeto é:

```text
batocera-h616-cb1
```

Os arquivos específicos do target estão em:

```text
configs/batocera-h616-cb1.board
board/batocera/allwinner/h616/cb1-poc/
```

Este fork acompanha a estrutura de build do Batocera. Dependendo do ambiente utilizado, o build pode ser executado localmente ou através do fluxo/container recomendado pelo próprio projeto Batocera.

Os arquivos gerados pelo build não são versionados:

```text
output/
output-container/
```

Também não é versionado o binário temporário:

```text
board/batocera/allwinner/h616/cb1-poc/u-boot-sunxi-with-spl.bin
```

---

## Estrutura resumida

```text
batocera.bttpi/
├── board/
│   └── batocera/
│       └── allwinner/
│           └── h616/
│               ├── cb1-poc/
│               │   ├── boot/
│               │   ├── fsoverlay/
│               │   ├── create-boot-script.sh
│               │   ├── genimage.cfg
│               │   └── linux.config.fragment
│               └── linux_patches/
│                   └── cb1-poc-sd-hdmi.patch
│
├── configs/
│   └── batocera-h616-cb1.board
│
├── buildroot/  -> aydasoft/buildroot
│
└── package/
    └── batocera/
```

---

## Relação com o upstream

Este repositório é um fork de:

**Batocera Linux**  
https://github.com/batocera-linux/batocera.linux

O Buildroot utilizado pelo projeto também deriva de:

**Batocera Buildroot**  
https://github.com/batocera-linux/buildroot

Estrutura do projeto:

```text
batocera-linux/batocera.linux
            │
            └── aydasoft/batocera.bttpi
                        │
                        └── buildroot
                              │
                              └── aydasoft/buildroot
```

O objetivo é manter as mudanças específicas do BTT-Pi isoladas e facilitar a integração de atualizações futuras do Batocera.

---

## Atualizando a partir do Batocera oficial

O repositório original pode ser mantido como `upstream`:

```bash
git remote -v
```

Exemplo esperado:

```text
origin    https://github.com/aydasoft/batocera.bttpi.git
upstream  https://github.com/batocera-linux/batocera.linux.git
```

Para buscar novas alterações:

```bash
git fetch upstream
```

Antes de integrar uma atualização do upstream, verifique também se houve mudança no commit do submódulo `buildroot`, pois as alterações específicas do BTT-Pi podem precisar ser reaplicadas sobre uma versão mais recente.

---

## Créditos

Este projeto existe graças ao trabalho dos projetos e comunidades envolvidos, incluindo:

- Batocera Linux;
- Buildroot;
- Linux;
- U-Boot;
- desenvolvedores dos drivers e componentes utilizados pelo Allwinner H616 e pelo RTL8189FS/RTL8188F.

As modificações específicas deste fork têm como objetivo adicionar suporte ao BTT-Pi / CB1 sem substituir ou ocultar o trabalho dos projetos originais.

---

## Licença

Este fork preserva as licenças dos projetos originais e dos componentes incorporados.

Consulte os arquivos de licença presentes no repositório e as licenças de cada componente para obter os termos aplicáveis.

---

## Aviso

**Batocera BTT-Pi não é uma versão oficial do Batocera Linux.**

O nome Batocera pertence ao respectivo projeto. Este repositório é um trabalho independente de adaptação para hardware não suportado oficialmente por este fork no momento de seu desenvolvimento.
