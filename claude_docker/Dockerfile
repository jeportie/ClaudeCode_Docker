# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/12 12:58:41 by jeportie          #+#    #+#              #
#    Updated: 2025/04/13 19:04:35 by jeportie         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Base System Configuration ************************************************** #
FROM jeportie/claude_base:latest

# Set the entrypoint to launch the customized shell ************************** #
COPY script/entrypoint.sh /sh/entrypoint.sh
RUN chmod +x /sh/entrypoint.sh
COPY script/run_claude.sh /sh/run_claude.sh
RUN chmod +x /sh/run_claude.sh

ENTRYPOINT ["/sh/entrypoint.sh"]
RUN git config --global user.email "jeportie@student.42.fr"
RUN git config --global user.name "jeportie"

# Export API keys
COPY script/load_api_keys.sh /sh/load_api_keys.sh
RUN chmod +x /sh/load_api_keys.sh

# COPY claude code mcp configs 
COPY claude_code/.claude/ /root/projects/.claude/
COPY claude_code/.mcp.json /root/projects/.mcp.json
COPY claude_code/just-prompt-mcp.json /root/projects/just-prompt-mcp.json

# COPY claude_code/just-prompt/ /root/projects/just-prompt
RUN git clone https://github.com/disler/just-prompt.git /root/projects/just-prompt
RUN cd /root/projects/just-prompt && pip install -e . && cd /root/projects/
