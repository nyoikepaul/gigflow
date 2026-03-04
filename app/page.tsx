"use client";
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Copy } from "lucide-react"

export default function Home() {
  const commands = [
    { cmd: "gigflow list-projects", out: "✅ Projects:\n- E-commerce Redesign: $4,500 (Active)\n- SaaS Dashboard: $7,200 (Pending)\n- Mobile App API: $3,000 (Completed)\n⏱️ Query time: 2s" },
    { cmd: "gigflow view-revenue", out: "📊 Revenue Chart:\nQ1: $15,000\nQ2: $22,500\n✅ Upwork integrations active\n🗄️ Data from TanStack Table" },
    { cmd: "gigflow add-client --name TechFlow", out: "✅ Client added\n✅ Form validated with Zod\n🚀 Animated with Framer Motion" },
    { cmd: "gigflow test-dashboard", out: "✅ Vitest + Playwright OK\n✅ shadcn/ui components loaded\n📡 Ready for production gigs" }
  ]

  const runDemo = (index: number) => {
    const output = document.getElementById('terminalOutput')
    if (output) {
      output.innerHTML = `<span class="text-blue-400">$ ${commands[index].cmd}</span><br><br>`
      const outDiv = document.createElement('div')
      outDiv.className = 'output'
      output.appendChild(outDiv)
      typeWriter(outDiv, commands[index].out)
    }
  }

  const typeWriter = (element: HTMLElement, text: string, speed = 20) => {
    element.innerHTML = ''
    let i = 0
    const type = () => {
      if (i < text.length) {
        element.innerHTML += text.charAt(i) === '\n' ? '<br>' : text.charAt(i)
        i++
        setTimeout(type, speed)
      }
    }
    type()
  }

  const copyInstall = () => {
    const cmd = `git clone https://github.com/nyoikepaul/gigflow.git && cd gigflow && npm install && npm run dev`
    navigator.clipboard.writeText(cmd).then(() => {
      const msg = document.getElementById('copyMsg')
      if (msg) {
        msg.classList.remove('hidden')
        setTimeout(() => msg.classList.add('hidden'), 4000)
      }
    }).catch(() => {
      alert("✅ Command copied manually:\n\n" + cmd)
    })
  }

  // Auto-run first demo
  setTimeout(() => runDemo(0), 600)

  return (
    <div className="min-h-screen bg-zinc-950 text-zinc-100 font-mono">
      <div className="max-w-5xl mx-auto px-6 py-12">
        {/* Hero */}
        <div className="text-center mt-16">
          <h1 className="text-6xl font-bold text-blue-400 tracking-tighter">💼 GIGFLOW</h1>
          <p className="text-2xl mt-4 text-zinc-400">Premium Freelance Dashboard • Next.js 16 • Win $3k–$10k Gigs</p>
          <p className="text-xl mt-2 text-blue-500">For Upwork freelancers & agencies in Kenya</p>
        </div>

        {/* One-click Install */}
        <div className="mt-12 flex justify-center">
          <Button onClick={copyInstall} className="bg-blue-500 hover:bg-blue-600 text-black font-bold text-xl px-12 py-6 rounded-3xl flex items-center gap-3 transition-all active:scale-95">
            <Copy className="w-5 h-5" />
            ONE-CLICK INSTALL (Free Version)
          </Button>
        </div>
        <p id="copyMsg" className="text-center text-blue-400 mt-4 text-sm hidden font-bold">✅ Command copied! Paste in your terminal now.</p>

        {/* Live Demo Terminal */}
        <div className="mt-16">
          <h2 className="text-3xl font-bold text-center mb-6 text-blue-400">Try the Dashboard LIVE</h2>
          <div id="demoTerminal" className="bg-black border-4 border-blue-500 rounded-3xl p-8 text-blue-400 text-base max-w-2xl mx-auto h-96 overflow-hidden flex flex-col shadow-2xl shadow-blue-500/30">
            <div className="flex items-center gap-2 mb-6">
              <div className="w-3 h-3 bg-red-500 rounded-full"></div>
              <div className="w-3 h-3 bg-yellow-500 rounded-full"></div>
              <div className="w-3 h-3 bg-green-500 rounded-full"></div>
              <span className="ml-4 text-zinc-500 text-sm">gigflow — freelance-dashboard</span>
            </div>
            <div id="terminalOutput" className="flex-1 text-sm overflow-y-auto leading-relaxed"></div>
            <div className="flex gap-3 mt-6 flex-wrap">
              <Button onClick={() => runDemo(0)} variant="outline" className="px-6 py-3 bg-zinc-900 hover:bg-blue-900 text-xs transition border-blue-900">List Projects</Button>
              <Button onClick={() => runDemo(1)} variant="outline" className="px-6 py-3 bg-zinc-900 hover:bg-blue-900 text-xs transition border-blue-900">View Revenue</Button>
              <Button onClick={() => runDemo(2)} variant="outline" className="px-6 py-3 bg-zinc-900 hover:bg-blue-900 text-xs transition border-blue-900">Add Client</Button>
              <Button onClick={() => runDemo(3)} variant="outline" className="px-6 py-3 bg-zinc-900 hover:bg-blue-900 text-xs transition border-blue-900">Test Dashboard</Button>
            </div>
          </div>
        </div>

        {/* Features */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mt-20">
          <Card className="bg-zinc-900 border-blue-900 hover:border-blue-400 transition">
            <CardHeader><CardTitle className="text-2xl font-bold text-blue-400">Gig Management</CardTitle></CardHeader>
            <CardContent><p className="text-zinc-400">Track projects with TanStack Table & Recharts</p></CardContent>
          </Card>
          <Card className="bg-zinc-900 border-blue-900 hover:border-blue-400 transition">
            <CardHeader><CardTitle className="text-2xl font-bold text-blue-400">Forms & Validation</CardTitle></CardHeader>
            <CardContent><p className="text-zinc-400">React Hook Form + Zod for seamless inputs</p></CardContent>
          </Card>
          <Card className="bg-zinc-900 border-blue-900 hover:border-blue-400 transition">
            <CardHeader><CardTitle className="text-2xl font-bold text-blue-400">Animations & Testing</CardTitle></CardHeader>
            <CardContent><p className="text-zinc-400">Framer Motion + Vitest/Playwright</p></CardContent>
          </Card>
        </div>

        {/* Pro CTA */}
        <div className="mt-20 text-center bg-gradient-to-r from-blue-950 to-zinc-900 border border-blue-500 rounded-3xl p-12">
          <h3 className="text-4xl font-bold">GigFlow <span className="text-blue-400">Pro</span></h3>
          <p className="text-2xl mt-4">KSh 1,099/month • Commercial license + advanced features + support</p>
          <a href="https://paulnyoike.carrd.co" target="_blank" rel="noopener noreferrer"
             className="inline-block mt-8 bg-blue-500 hover:bg-blue-600 text-black font-bold px-12 py-5 rounded-3xl text-xl transition">
            Get Pro Now →
          </a>
        </div>

        <div className="text-center mt-12">
          <a href="https://github.com/nyoikepaul/gigflow" target="_blank" rel="noopener noreferrer" className="text-zinc-500 hover:text-blue-400 text-lg">⭐ View full source on GitHub</a>
        </div>
      </div>
    </div>
  )
}
