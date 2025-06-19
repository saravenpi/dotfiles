export interface PageType {
  name: string;
  url: string;
  icon: string;
}

export const pages: PageType[] = [
  {
    name: "Dashboard",
    url: "/dashboard",
    icon: "lucide:layout-dashboard"
  },
  {
    name: "Profile",
    url: "/profile",
    icon: "lucide:user-round"
  },
  {
    name: "Settings",
    url: "/settings",
    icon: "lucide:settings-2"
  }
]
