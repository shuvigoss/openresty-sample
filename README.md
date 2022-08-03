## nginx master worker 模型
![image](https://user-images.githubusercontent.com/3062921/182550959-fc942ece-a852-4c0c-89bb-6537eb1aa060.png)

## nginx vs openresty
 OpenResty® 是一个基于 Nginx 与 Lua 的高性能 Web 平台，其内部集成了大量精良的 Lua 库、第三方模块以及大多数的依赖项。用于方便地搭建能够处理超高并发、扩展性极高的动态 Web 应用、Web 服务和动态网关。

 OpenResty® 通过汇聚各种设计精良的 Nginx 模块（主要由 OpenResty 团队自主开发），从而将 Nginx 有效地变成一个强大的通用 Web 应用平台。这样，Web 开发人员和系统工程师可以使用 Lua 脚本语言调动 Nginx 支持的各种 C 以及 Lua 模块，快速构造出足以胜任 10K 乃至 1000K 以上单机并发连接的高性能 Web 应用系统。

 OpenResty® 的目标是让你的Web服务直接跑在 Nginx 服务内部，充分利用 Nginx 的非阻塞 I/O 模型，不仅仅对 HTTP 客户端请求,甚至于对远程后端诸如 MySQL、PostgreSQL、Memcached 以及 Redis 等都进行一致的高性能响应。

![image](https://user-images.githubusercontent.com/3062921/182551770-dcbabce9-5196-4f94-a468-8ee4ac67bdcc.png)

![image](https://user-images.githubusercontent.com/3062921/182552195-fb07a1ba-a114-430d-9f74-a0da7707d1c0.png)

## 指令执行顺序
![image](https://user-images.githubusercontent.com/3062921/182553194-72821cc8-9761-4b39-aef3-185e0b34006f.png)

## 安装
``` bash
luarocks install api7-lua-tinyyaml --tree=deps
luarocks install lua-resty-radixtree --tree=deps
luarocks install lua-resty-iputils --tree=deps

##必须要手动创建
mkdir logs
```

## TODO
* 手动编译安装nginx
* 手动编译安装openresty
* 尝试写一些代码