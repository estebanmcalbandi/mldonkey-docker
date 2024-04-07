docker create --name my-mldonkey --restart=always -p 4080:4080 -p 4000:4000 -p 4001:4001 -p 20562:20562 -p 20566:20566/udp -p 16965:16965/udp -v /share/homes/emc2/.mldonkey:/var/lib/mldonkey mldonkey
