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
