// Finicky 4.x config. Matchers take (url, { opener }) as positional args -
// the v3 single-object form ({ url, opener }) silently breaks here.
// https://github.com/johnste/finicky/wiki

const WORK = "Google Chrome";
const PERSONAL = "Brave Browser";

const SLACK = "com.tinyspeck.slackmacgap";

export default {
  defaultBrowser: PERSONAL,

  handlers: [
    {
      match: [
        "*meet.google.com*",
        "*calendar.google.com*",
        "*notion.so*",
        "*slack.com*",
        "*loom.com*",
        "*figma.com*",
        "*gitlab.com*",
        "*console.aws.amazon.*",
        "*aws.amazon.*",
      ],
      browser: WORK,
    },
    {
      match: /zoom\.us\/join/,
      browser: "us.zoom.xos",
    },
    {
      match: ["*open.spotify.com/*"],
      browser: "Spotify",
    },
    {
      // Personal reading stays personal even when opened from a work app
      match: ["*youtube.com*", "*reddit.com*"],
      browser: PERSONAL,
    },
    {
      match: (url) => url.hostname.includes("demoboost"),
      browser: WORK,
    },
    {
      // Anything else clicked in Slack is work
      match: (_url, { opener }) => opener?.bundleId === SLACK,
      browser: WORK,
    },
  ],

  rewrite: [
    {
      // Send zoom meeting links straight to the app instead of the browser
      match: (url) =>
        url.hostname.includes("zoom.us") && url.pathname.includes("/j/"),
      url: (url) => {
        const conf = url.pathname.match(/\/j\/(\d+)/)?.[1];
        if (!conf) return url;
        const pwd = url.search.match(/pwd=(\w+)/)?.[1];
        return `zoommtg://zoom.us/join?confno=${conf}${pwd ? `&pwd=${pwd}` : ""}`;
      },
    },
  ],
};
