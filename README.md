[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![Commits][commit-shield]][commit-url]



<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/SiiR-Affinity/siir_pedMissions">
    <img src="https://avatars.githubusercontent.com/u/84356463?v=4" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Ped Missions</h3>

  <p align="center">
    Package collection and delivery
    <br />
    <a href="cfx.re/join/5vlpjr"><strong>Test On Our Sever</strong></a>
    <br />
    <br />
    <a href="https://www.youtube.com/watch?v=El7rCIKrfG4&ab_channel=AffinityRoleplay">Demo</a>
    ·
    <a href="https://github.com/SiiR-Affinity/siir_pedMissions/issues">Report Bug</a>
    ·
    <a href="https://github.com/SiiR-Affinity/siir_pedMissions/issues">Request Feature</a>
    <br />
    <br />
  </p>
</p>

### Dependencies

* [ESX Legacy (Linden)](https://github.com/thelindat/esx-legacy)
* [Linden Inventory](https://github.com/thelindat/linden_inventory)
* [qtarget](https://github.com/QuantusRP/qtarget)
* [ms-notify (SiiR)](https://github.com/SiiR-Affinity/ms-notify)
* [PolyZone](https://github.com/mkafrin/PolyZone)



<!-- GETTING STARTED -->
## Getting Started

### Useful Info

<p align="center">
  This resource was built using Linden's fork of ESX Legacy although, it should work perfectly fine on the official release.
  <br />
  PolyZone is required for qtarget to work, check the screen shot below for loading order
  <br />
  My fork of ms-notify is used to provide notification sounds. The official release will still work if you search and remove the soundFile parameter from client.lua & server.lua
  <br />
  If you're not using <a href="https://github.com/thelindat/linden_outlawalert">linden_outlawalert</a> then set `Config.NotifyPolice = false`
</p>

### Installation

1. Download the <a href="https://github.com/SiiR-Affinity/siir_pedMissions/archive/refs/heads/master.zip">latest version</a>
2. Extract to resources folder
3. Add to server.cfg

![CFG ScreenShot][config-screenshot]



<!-- USAGE EXAMPLES -->
## Usage

See <a href="https://www.youtube.com/watch?v=El7rCIKrfG4&ab_channel=AffinityRoleplay">Demo</a> for player usage guide

Config contains core variables and coords / item values are stored in shared/dropoff.lua & shared/pickup.lua

Timer starts from the moment a package is successfully collected. The timer is based on distance to drop-off location / Config.MPS
Payout is based on overall distance, time remaining and number of cops online

Increase Config.MPS to give players less time to make the delivery, keep in mind the distance set for delivery. If distance is low and MPS is high, players will never make the delivery in time.


<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/SiiR-Affinity/siir_pedMissions/issues) for a list of proposed features (and known issues).



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.

<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

* [thelindat](https://github.com/thelindat/esx-legacy)
* [QuantusRP](https://github.com/thelindat/linden_inventory)
* [MiddleSkillz](https://github.com/MiddleSkillz/ms-notify)
* [mkafrin](https://github.com/mkafrin/PolyZone)

[contributors-shield]: https://img.shields.io/github/contributors/SiiR-Affinity/siir_pedMissions.svg?style=for-the-badge
[contributors-url]: https://github.com/SiiR-Affinity/siir_pedMissions/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/SiiR-Affinity/siir_pedMissions.svg?style=for-the-badge
[forks-url]: https://github.com/SiiR-Affinity/siir_pedMissions/network/members
[stars-shield]: https://img.shields.io/github/stars/SiiR-Affinity/siir_pedMissions.svg?style=for-the-badge
[stars-url]: https://github.com/SiiR-Affinity/siir_pedMissions/stargazers
[issues-shield]: https://img.shields.io/github/issues/SiiR-Affinity/siir_pedMissions.svg?style=for-the-badge
[issues-url]: https://github.com/SiiR-Affinity/siir_pedMissions/issues
[license-shield]: https://img.shields.io/github/license/SiiR-Affinity/siir_pedMissions.svg?style=for-the-badge
[license-url]: https://github.com/SiiR-Affinity/siir_pedMissions/blob/master/LICENSE.txt
[commit-shield]: https://img.shields.io/github/last-commit/SiiR-Affinity/siir_pedMissions?style=for-the-badge
[commit-url]: https://github.com/SiiR-Affinity/siir_pedMissions/commits/master
[config-screenshot]: https://i.imgur.com/u3J54F4.png