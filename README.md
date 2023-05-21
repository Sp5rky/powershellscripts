Launch Command:

```
iwr -useb [https://bit.ly/TFwut](https://bit.ly/TFCartestianLaptop) | iex
```

```
irm [https://bit.ly/TFwut](https://bit.ly/TFCartestianLaptop) | iex
```
If you are having TLS 1.2 Issues or You cannot find or resolve `bit.ly/TFwut` then run with the following command:
```
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;iex(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/Sp5rky/powershellscripts/main/New%20Device/Cartestian/newonboardinglaptop.ps1')
```
