FROM node
ENV mode client_or_server
RUN git clone --depth 1 https://github.com/tompng/wrtc_tunnel
RUN cd wrtc_tunnel && npm install
RUN cd wrtc_tunnel && npx tsc --outDir dist
CMD ["sleep", "999999999"]
