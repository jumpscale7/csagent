#
# Copyright (C) 2009-2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=csagent
PKG_SOURCE_VERSION:=8ff3647efbbbe65188fb87b8c09d87f62ed9a2ec
PKG_VERSION:=1
PKG_RELEASE:=5
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.bz2
PKG_SOURCE_URL:=https://git.aydo.com/binary/csagent.git
PKG_SOURCE_SUBDIR:=csagent.git
PKG_SOURCE_PROTO:=git

include $(INCLUDE_DIR)/package.mk

define Package/csagent
  SECTION:=base
  CATEGORY:=Network
  TITLE:=CSAgent
  URL:=https://github.com/Jumpscale/csagent
  MAINTAINER:=Amr Hassan <amr.hassan@codescalers.com>
  DEPENDS:=+lua
endef

define Package/csagent/description
	A JumpScale agent implementation for embedded devices.
endef

define Build/Configure
endef

define Build/Compile
endef


define Package/csagent/install
	$(INSTALL_DIR) $(1)/usr/share/csagent
	$(INSTALL_DIR) $(BUILD_DIR)/csagent.git/deps $(1)/usr/share/csagent/deps
	$(INSTALL_DATA) $(BUILD_DIR)/csagent.git/agentcontroller.lua $(1)/usr/share/csagent/agentcontroller.lua
	$(INSTALL_DATA) $(BUILD_DIR)/csagent.git/csagent.lua $(1)/usr/share/csagent/csagent.lua
	$(INSTALL_DATA) $(BUILD_DIR)/csagent.git/log.lua $(1)/usr/share/csagent/log.lua
	$(INSTALL_DATA) $(BUILD_DIR)/csagent.git/utils.lua $(1)/usr/share/csagent/utils.lua
	$(INSTALL_DATA) $(BUILD_DIR)/csagent.git/args.lua $(1)/usr/share/csagent/args.lua
	$(INSTALL_DATA) $(BUILD_DIR)/csagent.git/jobs.lua $(1)/usr/share/csagent/jobs.lua
	$(INSTALL_DATA) $(BUILD_DIR)/csagent.git/netinfo.lua $(1)/usr/share/csagent/netinfo.lua

endef

$(eval $(call BuildPackage,csagent))
