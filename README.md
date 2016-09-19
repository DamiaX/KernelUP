About:<blockquote>
**KernelUP** is a program to automatically update the kernel for **Ubuntu**, **Ubuntu-Mate**, **Debian**, **elementary OS** and **Linux Mint**.
</blockquote>
<hr>
Features:<br>
<blockquote>
* Autostart.<br>
* Automatically checking for kernel version.<br>
* Notifications about new kernel version.<br>
* Automatic updates KernelUP.<br>
* The translations (Polish and English).<br>
* Removing older versions of the kernel.<br>
* System Plugin.<br>
* Auto rebuild VirtualBox modules.<br>
* Automatically install updates.<br>

</blockquote>
<hr>
GUI Install:<br>
<blockquote>
Download this: https://raw.githubusercontent.com/DamiaX/kernelup/master/kernelup.sh file.<br>
Give permissions to run.
Run as root this file on terminal.
</blockquote>
<hr>
Terminal Install:<br>
<blockquote>
Step 1: Download (Method 1/2: Use <code>wget</code> to download a install script and give permissions to run)
<pre><code>wget https://raw.githubusercontent.com/DamiaX/kernelup/master/kernelup.sh -O kernelup; 
chmod +x kernelup</code></pre>

Step 1: Download (Method 2/2: Use <code>curl</code> to download a install script and give permissions to run)
<pre><code>curl https://raw.githubusercontent.com/DamiaX/kernelup/master/kernelup.sh > kernelup;
chmod +x kernelup</code></pre>

Step 2: Run as root the <code>kernelup</code> script.
<pre><code>sudo ./kernelup</code></pre>
</blockquote>
<hr>
Uninstall KernelUP:<br>
<blockquote>
Method 1: Manually uninstalling the program files.<br>
<code>sudo rm -rf /tmp/kernelup*</code> deleting temp files program.<br>
<code>sudo rm -rf /usr/share/icons/hicolor/128x128/apps/kernelup.png</code> removing a program icon.<br>
<code>sudo rm -rf ~/.config/autostart/kernelup-init.desktop</code> removing autostart applications.<br>
<code>sudo rm -rf /usr/local/sbin/kernelup*</code> removing the application<br>
<code>sudo rm -rf /usr/share/applications/kernelup-init.desktop</code> delete the '.desktop' file.<br>
<code>sudo rm -rf $HOME/.KernelUP_data</code> removing configuration files.<br>
      
Method 2: Starting automatic uninstaller<br>
<code>sudo kernelup -r</code><br>
</blockquote>
<hr>
Advanced usage examples and notes:<blockquote>
<code>-h</code> or <code>--help</code> view the content of help.<br>
<code>-v</code> or <code>--version</code> display the version of the program.<br>
<code>-k</code> or <code>--kernel_update</code> check for a new version of the kernel.<br>
<code>-u</code> or <code>--update</code> check the available program updates.<br>
<code>-r</code> or <code>--remove</code> remove application.<br>
<code>-R</code> or <code>--rkernel</code> delete old versions of the kernel in order to free up disk space.<br>
<code>-c</code> or <code>--copy</code> install program.<br>
<code>-a</code> or <code>--author</code> display information about the author of the program.<br>
<code>-pi</code> or <code>--plugin-installer</code> install additional plugins for the program.<br>
</blockquote>
<hr>

Create and install Plugin for KernelUP<br>
<blockquote>

Install Plugin:<br>

* To install the plugin just move it to the directory: "~/.KernelUP_data/Plugins/" -- <pre><code>mv PLUGIN_NAME.kernelup $HOME/.KernelUP_data/Plugins/</code></pre>

Create Plugin:<br>
* Download a sample: https://raw.githubusercontent.com/DamiaX/KernelUP/master/Plugins/example.kernelup plugin. -- <pre><code>wget https://raw.githubusercontent.com/DamiaX/KernelUP/master/Plugins/example.kernelup</code></pre> and see its structure.

</blockquote>
<hr>
Official plugins:<br>
<blockquote>
* Cleaner (https://raw.githubusercontent.com/DamiaX/KernelUP/master/Plugins/system_clean.kernelup) is an automatic cleaner system. <br>
Instalation:<br>
Method 1: Manual installation<br>
<pre><code>wget https://raw.githubusercontent.com/DamiaX/KernelUP/master/Plugins/system_clean.kernelup -O system_clean.kernelup; chmod +x system_clean.kernelup; mv system_clean.kernelup $HOME/.KernelUP_data/Plugins/system_clean.kernelup;</code></pre><br>
Method 2: Automatic installation<br>
<pre><code>kernelup -pi https://raw.githubusercontent.com/DamiaX/KernelUP/master/Plugins/system_clean.kernelup</code></pre><br>

* Help others (https://raw.githubusercontent.com/DamiaX/KernelUP/master/Plugins/help_others.kernelup) visited pages automatically charity in order to click on reflink.<br>
Instalation:<br>
Method 1: Manual installation<br>
<pre><code>wget https://raw.githubusercontent.com/DamiaX/KernelUP/master/Plugins/help_others.kernelup -O help_others.kernelup; chmod +x help_others.kernelup; mv help_others.kernelup $HOME/.KernelUP_data/Plugins/help_others.kernelup;</code></pre><br>
Method 2: Automatic installation<br>
<pre><code>kernelup -pi https://raw.githubusercontent.com/DamiaX/KernelUP/master/Plugins/help_others.kernelup</code></pre><br>

</blockquote>

Author:<br>
<blockquote>
Damian Majchrzak (https://www.facebook.com/DamiaX).
</blockquote>
