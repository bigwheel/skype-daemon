# skype-daemon-cookbook

skype daemon for 3rd party API

## Supported Platforms

Only ubuntu 15.04

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Required</th>
  </tr>
  <tr>
    <td><tt>['skype-daemon']['app-name']</tt></td>
    <td>String</td>
    <td>App name what wants to<br />use Skype 3rd party API.<br />e.g. 'Skype4Java'</td>
    <td><tt>True</tt></td>
  </tr>
  <tr>
    <td><tt>['skype-daemon']['username']</tt></td>
    <td>String</td>
    <td>Skype username</td>
    <td><tt>True</tt></td>
  </tr>
  <tr>
    <td><tt>['skype-daemon']['password']</tt></td>
    <td>String</td>
    <td>Skype password(plain text)</td>
    <td><tt>True</tt></td>
  </tr>
</table>

## Usage

### skype-daemon::default

Include `skype-daemon` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[skype-daemon::default]"
  ]
}
```

## License and Authors

MIT License
k.bigwheel(k.bigwheel+eng @ gmail.com)
