# PharoEDA Ports

This project inspects the published [PharoEDA-Adapters](https://github.com/osoco/pharo-eda-adapters "PharoEDA-Adapters") and makes them available to create new `EDAApplication` instances.

## Motivation

PharoEDA applications use ports and adapters, so they are decoupled from the actual technologies used.
This project listens to [adapter-related events](https://github.com/osoco/pharo-eda-adapters "adapter-related events"), projects them, and make them accessible when creating `EDAApplication`s.

## Design

PharoEDA-Ports listen to `Announcement`s from [PharoEDA-Adapters](https://github.com/osoco/pharo-eda-adapters "PharoEDA-Adapters"), and maintain a read model with the available adapters.

## Usage

First, load it with Metacello:

```smalltalk
Metacello new repository: 'github://osoco/pharo-eda-ports:main'; baseline: #PharoEDAPorts; load
```

Then, run it with

```smalltalk
PharoEDAPorts run
```

## Work in progress

- Support for current PharoEDA adapters: MongoDB, STOMP.

## Credits

- Background of the Pharo image by <a href="https://pixabay.com/users/timhill-5727184/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=2444029">Tim Hill</a> from <a href="https://pixabay.com/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=2444029">Pixabay</a>
