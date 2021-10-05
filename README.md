# RootFSProvider

This sample project was previously available on on Patreon. It is written in Objective-C, and has not been updated for newer APIs since 2017.

### Original description

I've had quite a few requests for my work-in-progress rootfs Files provider extension, and though I plan to make it available on GitHub at some later stage, I thought I would share the early work here with you.

It has its limitations — while you can browse most of the filesystem (read-only) at will, and preview certain kinds of files, the nature of how file providers works means that any file it previews it has to copy to its sandbox first, which is unfortunate. Sure would be a nice place to use APFS APIs to make copies 'free'…

There aren't very many examples of a working iOS 11 file provider, so as sample code it might be worth a look alone.

### Screenshot

![](https://hccdata.s3.us-east-1.amazonaws.com/gh_rootfsprovider.jpg)
