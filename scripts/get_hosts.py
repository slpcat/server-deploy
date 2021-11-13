#!/usr/bin/env python3

# 从inventory/all.yml中提取出某些环境的主机
# ./get_hosts.py [dev]|stress]

import re
import sys
import yaml
from queue import Queue

ipv4_pattern = re.compile(r'((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})(\.((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})){3}')
f = open("../inventory/all.yml", "r")
data = yaml.full_load(f)
f.close()
if not isinstance(data, dict):
    print("invalid yaml format")
    exit(1)


def main():
    if len(sys.argv) > 1:
        dfs()
    else:
        bfs()


def dfs():
    path_list = list()
    _dfs(data, path_list)


def _dfs(elem, path_list):
    if isinstance(elem, dict):
        for key in elem.keys():
            path_list.append(key)
            _dfs(elem[key], path_list)
    else:  # 叶子节点
        leaf = path_list[-1]
        intersection = set(path_list) & set(sys.argv)
        if ipv4_pattern.search(leaf) and intersection:
            print(leaf)
    if path_list:
        path_list.pop()


def bfs():
    q = Queue(maxsize=0)
    q.put_nowait(data)
    while not q.empty():
        elem = q.get_nowait()
        for key in elem.keys():
            if isinstance(elem[key], dict):
                q.put_nowait(elem[key])
            elif ipv4_pattern.search(key):
                print(key)


def debug():
    print(data.keys())
    for child in data.values():
        print(child.keys())


if __name__ == '__main__':
    main()
