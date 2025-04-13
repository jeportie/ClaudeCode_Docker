# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/12 12:58:41 by jeportie          #+#    #+#              #
#    Updated: 2025/04/04 01:32:44 by JeromeP          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Base System Configuration ************************************************** #
FROM jeportie/nvjej_base:latest

# Set the entrypoint to launch the customized shell ************************** #
COPY script/entrypoint.sh /sh/entrypoint.sh
RUN chmod +x /sh/entrypoint.sh
ENTRYPOINT ["/sh/entrypoint.sh"]
RUN git config --global user.email "jeportie@student.42.fr"
RUN git config --global user.name "jeportie"

# Bash Scripts copy ********************************************************** #
COPY script/update_makefile.sh /sh/update_makefile.sh
COPY script/run_with_args.sh /sh/run_with_args.sh
COPY script/val_with_args.sh /sh/val_with_args.sh

# Export API keys
COPY script/load_api_keys.sh /sh/load_api_keys.sh
RUN chmod +x /sh/load_api_keys.sh

# Install the latest stable Neovim + NVChad Base Disrto ********************** #
RUN wget https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.tar.gz && \
    tar -xzf nvim-linux-x86_64.tar.gz && \
    cp -r nvim-linux-x86_64/* /usr/local/ && \
    rm -rf nvim-linux-x86_64.tar.gz nvim-linux-x86_64
RUN git clone https://github.com/NvChad/starter ~/.config/nvim && \
    rm -rf ~/.config/nvim/.git

# Trigger lazy.nvim to sync plugins in headless mode ************************* #
RUN nvim --headless +"Lazy! sync" +qa
# Copy lua config files ****************************************************** #
COPY lua/chadrc.lua /root/.config/nvim/lua/chadrc.lua
COPY lua/options.lua /root/.config/nvim/lua/options.lua
COPY lua/cmp.lua /root/.local/share/nvim/lazy/NvChad/lua/nvchad/configs/cmp.lua
COPY lua/lspconfig.lua /root/.config/nvim/lua/configs/lspconfig.lua
COPY lua/lsp_servers.lua /root/.config/nvim/lua/custom/lsp_servers.lua
COPY lua/lazy.lua /root/.config/nvim/lua/plugins/lazy.lua
COPY lua/mappings.lua /root/.config/nvim/lua/custom/mappings.lua
COPY lua/null-ls.lua /root/.config/nvim/lua/custom/configs/null-ls.lua
COPY lua/mappings.lua /root/.local/share/nvim/lazy/NvChad/lua/nvchad/mappings.lua
COPY lua/term_init.lua /root/.local/share/nvim/lazy/ui/lua/nvchad/term/init.lua
# Trigger lazy.nvim to sync plugins in headless mode ************************* #
RUN nvim --headless +"Lazy! sync" +qa

# COPY mounted volumes to default
RUN cp -r /root/.cache /root/.default.cache
RUN cp -r /root/.config /root/.default.config
RUN cp -r /root/.local /root/.default.local

# COPY AI prompts
COPY ai_prompts/ /root/.ai_prompts

# COPY avante mcp congif file
COPY config/mcpservers.json /root/.mcp/mcpservers.json

# COPY claude code mcp configs 
COPY claude_code/.claude/ /root/projects/.claude/
COPY claude_code/.mcp.json /root/projects/.mcp.json
COPY claude_code/just-prompt-mcp.json /root/projects/just-prompt-mcp.json

# COPY claude_code/just-prompt/ /root/projects/just-prompt
RUN git clone https://github.com/disler/just-prompt.git /root/projects/just-prompt
RUN cd /root/projects/just-prompt && pip install -e . && cd /root/projects/

# COPY zsh
COPY config/nvjej.zshrc /root/.zshrc

# COPY 42 clang-format
COPY config/42form.clang-format /root/.clang-format-styles/42form
