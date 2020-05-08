Name:		rabbitmq_exporter
Version:	2020.1
Release:	1%{?dist}
Summary:	RabbitMQ exporter for Prometheus

Group:		Monitoring
License:	MIT
URL:		https://github.com/kbudde/rabbitmq_exporter
Source0:	rabbitmq_exporter-2020.1.tar.gz

#BuildRequires:
#Requires:

%description
Prometheus exporter for RabbitMQ metrics. Data is scraped by prometheus.


%prep
%setup -q


%install
rm -rf $RPM_BUILD_ROOT
mkdir -p %{buildroot}/usr/bin/
mkdir -p %{buildroot}/etc/rabbitmq_exporter/
mkdir -p %{buildroot}/usr/lib/systemd/system/

cp rabbitmq_exporter %{buildroot}/usr/bin/rabbitmq_exporter
chmod 0755 %{buildroot}/usr/bin/rabbitmq_exporter

cp config.json %{buildroot}/etc/rabbitmq_exporter/

cp rabbitmq_exporter.service %{buildroot}/usr/lib/systemd/system/

%post
%systemd_post rabbitmq_exporter

%preun
%systemd_preun rabbitmq_exporter

%postun
%systemd_postun_with_restart rabbitmq_exporter

%files
/usr/bin/rabbitmq_exporter
/usr/lib/systemd/system/rabbitmq_exporter.service
/etc/rabbitmq_exporter/


%changelog
* Thu Apr 2 2020 foobargem <agfe09@gmail.com> - 2020.1
- Initial packaging
